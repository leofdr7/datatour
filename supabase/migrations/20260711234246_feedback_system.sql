
-- Extender tabla places con campos de confianza
alter table places
  add column nivel_confianza text check (nivel_confianza in ('alto', 'medio', 'bajo')) default 'alto',
  add column ultima_verificacion timestamptz default now();

-- Tabla: feedback_log (historial de reportes)
create table feedback_log (
  id uuid primary key default gen_random_uuid(),
  place_id uuid not null references places(id) on delete cascade,
  senial text not null check (senial in ('confirmado_abierto', 'reportado_cerrado', 'info_desactualizada')),
  fuente_app text,
  created_at timestamptz default now()
);


-- Índices

create index idx_feedback_place_id on feedback_log(place_id);
create index idx_feedback_created_at on feedback_log(created_at);
create index idx_places_nivel_confianza on places(nivel_confianza);

-- Función: recalcular nivel_confianza de un lugar
-- según los reportes recientes (últimos 30 días)
create or replace function actualizar_nivel_confianza(p_place_id uuid)
returns void as $$
declare
  reportes_cerrado int;
  reportes_confirmado int;
  nuevo_nivel text;
begin
  select count(*) into reportes_cerrado
  from feedback_log
  where place_id = p_place_id
    and senial in ('reportado_cerrado', 'info_desactualizada')
    and created_at > now() - interval '30 days';

  select count(*) into reportes_confirmado
  from feedback_log
  where place_id = p_place_id
    and senial = 'confirmado_abierto'
    and created_at > now() - interval '30 days';

  if reportes_cerrado >= 3 then
    nuevo_nivel := 'bajo';
  elsif reportes_cerrado >= 1 then
    nuevo_nivel := 'medio';
  elsif reportes_confirmado >= 1 then
    nuevo_nivel := 'alto';
  else
    nuevo_nivel := 'alto'; -- default si no hay señales recientes
  end if;

  update places
  set nivel_confianza = nuevo_nivel,
      ultima_verificacion = now()
  where id = p_place_id;
end;
$$ language plpgsql;

-- Trigger: recalcular automáticamente cada vez
-- que se inserta un nuevo feedback
create or replace function trigger_actualizar_confianza()
returns trigger as $$
begin
  perform actualizar_nivel_confianza(new.place_id);
  return new;
end;
$$ language plpgsql;

create trigger on_feedback_insert
  after insert on feedback_log
  for each row
  execute function trigger_actualizar_confianza();

-- Row Level Security
alter table feedback_log enable row level security;

-- Cualquiera puede insertar un reporte (POST /feedback público)
create policy "Permitir insertar feedback"
  on feedback_log for insert
  with check (true);

-- Cualquiera puede leer el historial de feedback (opcional, útil para debug/transparencia)
create policy "Permitir lectura publica de feedback"
  on feedback_log for select
  using (true);