import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'GET, OPTIONS',
}

Deno.serve(async (req) => {
  // Preflight de CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? ''
    )

    const url = new URL(req.url)
    const categoria = url.searchParams.get('categoria')
    const ciudad = url.searchParams.get('ciudad')

    let query = supabase.from('places').select('*')

    if (categoria) {
      const categoriasValidas = ['cultura', 'eco', 'gastronomia', 'creativo']
      if (!categoriasValidas.includes(categoria)) {
        return new Response(
          JSON.stringify({
            error: `categoria inválida. Usa uno de: ${categoriasValidas.join(', ')}`,
          }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        )
      }
      query = query.eq('tipo', categoria)
    }

    if (ciudad) {
      query = query.ilike('ciudad', `%${ciudad}%`)
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