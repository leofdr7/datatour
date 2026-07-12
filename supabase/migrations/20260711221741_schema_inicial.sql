-- Extensión necesaria para generar UUIDs automáticamente
create extension if not exists "pgcrypto";

-- Tabla: places (lugares turísticos)

create table places (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  tipo text not null check (tipo in ('cultura', 'eco', 'gastronomia', 'creativo')),
  descripcion_corta text,
  ciudad text not null,
  lat numeric,
  long numeric,
  horario text,
  precio_aproximado text,
  accesibilidad text,
  tags text[] default '{}',
  created_at timestamptz default now()
);

-- Tabla: events (eventos turísticos)
create table events (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  fecha_hora timestamptz not null,
  place_id uuid references places(id) on delete set null,
  tipo_actividad text,
  cupo integer,
  organizador text,
  created_at timestamptz default now()
);

-- Tabla: providers (microemprendedores)
create table providers (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  contacto text,
  redes_sociales text,
  servicios text,
  nivel_visibilidad text check (nivel_visibilidad in ('bajo', 'medio', 'alto')) default 'bajo',
  place_id uuid references places(id) on delete set null,
  created_at timestamptz default now()
);

-- Índices para acelerar las consultas más comunes de la API
create index idx_places_tipo on places(tipo);
create index idx_places_ciudad on places(ciudad);
create index idx_events_fecha on events(fecha_hora);
create index idx_providers_servicios on providers(servicios);
create index idx_providers_visibilidad on providers(nivel_visibilidad);

-- Habilitar Row Level Security (RLS)
alter table places enable row level security;
alter table events enable row level security;
alter table providers enable row level security;

-- Política: permitir lectura pública (SELECT) a cualquiera
-- Esto es lo que se necesita para que otros equipos consuman tu API sin autenticación
create policy "Permitir lectura publica de places"
  on places for select
  using (true);

create policy "Permitir lectura publica de events"
  on events for select
  using (true);

create policy "Permitir lectura publica de providers"
  on providers for select
  using (true);