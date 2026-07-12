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
    const tipo = url.searchParams.get('tipo')
    const nivelVisibilidad = url.searchParams.get('nivel_visibilidad')

    let query = supabase.from('providers').select('*')

    if (tipo) {
      query = query.ilike('servicios', `%${tipo}%`)
    }

    if (nivelVisibilidad) {
      const nivelesValidos = ['bajo', 'medio', 'alto']
      if (!nivelesValidos.includes(nivelVisibilidad)) {
        return new Response(
          JSON.stringify({
            error: `nivel_visibilidad inválido. Usa uno de: ${nivelesValidos.join(', ')}`,
          }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        )
      }
      query = query.eq('nivel_visibilidad', nivelVisibilidad)
    }

    const { data, error } = await query.order('nombre', { ascending: true })

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