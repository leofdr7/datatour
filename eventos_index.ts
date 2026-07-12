import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'GET, OPTIONS',
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? ''
    )

    const url = new URL(req.url)
    const fecha = url.searchParams.get('fecha')

    // Trae también el nombre y ciudad del lugar relacionado (join implícito)
    let query = supabase
      .from('events')
      .select('*, places(nombre, ciudad)')
      .order('fecha_hora', { ascending: true })

    if (fecha) {
      const fechaRegex = /^\d{4}-\d{2}-\d{2}$/
      if (!fechaRegex.test(fecha)) {
        return new Response(
          JSON.stringify({ error: 'fecha debe tener formato YYYY-MM-DD' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        )
      }
      const inicio = `${fecha}T00:00:00`
      const fin = `${fecha}T23:59:59`
      query = query.gte('fecha_hora', inicio).lte('fecha_hora', fin)
    }

    const { data, error } = await query

    if (error) throw error

    return new Response(
      JSON.stringify({ data, count: data?.length ?? 0 }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (err) {
    return new Response(
      JSON.stringify({ error: err instanceof Error ? err.message : 'Error interno' }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})