create table pending_registrations (
  from_number text primary key,
  datos_parciales jsonb not null default '{}',
  updated_at timestamptz default now()
);

alter table pending_registrations enable row level security;

create policy "Permitir lectura publica de pending_registrations"
  on pending_registrations for select
  using (true);

create policy "Permitir insertar/actualizar pending_registrations"
  on pending_registrations for all
  using (true)
  with check (true);