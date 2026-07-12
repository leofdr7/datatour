import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  if (req.method !== 'POST') {
    return new Response(
      JSON.stringify({ error: 'Método no permitido. Usa POST.' }),
      { status: 405, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }

  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? ''
    )

    const body = await req.json().catch(() => null)
    if (!body) {
      return new Response(
        JSON.stringify({ error: 'Body inválido. Se espera JSON.' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const { place_id, senial, fuente_app } = body

    if (!place_id || !senial) {
      return new Response(
        JSON.stringify({ error: 'place_id y senial son obligatorios' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const senialesValidas = ['confirmado_abierto', 'reportado_cerrado', 'info_desactualizada']
    if (!senialesValidas.includes(senial)) {
      return new Response(
        JSON.stringify({
          error: `senial inválida. Usa uno de: ${senialesValidas.join(', ')}`,
        }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Verifica que el lugar exista antes de insertar el feedback
    const { data: place, error: placeError } = await supabase
      .from('places')
      .select('id')
      .eq('id', place_id)
      .single()

    if (placeError || !place) {
      return new Response(
        JSON.stringify({ error: 'place_id no existe' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const { data: feedback, error: insertError } = await supabase
      .from('feedback_log')
      .insert({ place_id, senial, fuente_app: fuente_app ?? 'desconocido' })
      .select()
      .single()

    if (insertError) throw insertError

    // El trigger on_feedback_insert ya recalculó nivel_confianza en este punto.
    // Consultamos el place actualizado para devolverlo en la respuesta.
    const { data: placeActualizado } = await supabase
      .from('places')
      .select('id, nombre, nivel_confianza, ultima_verificacion')
      .eq('id', place_id)
      .single()

    return new Response(
      JSON.stringify({ feedback, place_actualizado: placeActualizado }),
      { status: 201, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (err) {
    return new Response(
      JSON.stringify({ error: err instanceof Error ? err.message : 'Error interno' }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})