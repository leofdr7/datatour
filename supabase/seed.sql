-- =========================================
-- DataTour - Seed data
-- Datos de ejemplo: San Salvador y alrededores
-- =========================================
 
-- -----------------------------------------
-- PLACES (lugares turísticos)
-- -----------------------------------------
insert into places (id, nombre, tipo, descripcion_corta, ciudad, lat, long, horario, precio_aproximado, accesibilidad, tags) values
  ('a1111111-1111-1111-1111-111111111111', 'Museo Nacional de Antropología David J. Guzmán', 'cultura', 'Museo con piezas arqueológicas y etnográficas de El Salvador', 'San Salvador', 13.6889, -89.2182, '09:00-16:30', '$3', 'Rampa de acceso, baños adaptados', array['museo','historia','arqueologia']),
  ('a2222222-2222-2222-2222-222222222222', 'Teatro Nacional de San Salvador', 'cultura', 'Teatro histórico con funciones de danza, música y teatro', 'San Salvador', 13.6980, -89.1912, '10:00-18:00', 'Variable segun evento', 'Acceso principal con rampa', array['teatro','arte','centro-historico']),
  ('a3333333-3333-3333-3333-333333333333', 'Mirador El Boquerón', 'eco', 'Mirador del cráter del volcán de San Salvador con senderos naturales', 'San Salvador', 13.7350, -89.2836, '08:00-17:00', '$1', 'Terreno irregular, no apto para sillas de ruedas', array['volcan','mirador','senderismo']),
  ('a4444444-4444-4444-4444-444444444444', 'Parque Cuscatlán', 'eco', 'Parque urbano con áreas verdes, ciclovía y monumentos', 'San Salvador', 13.6997, -89.2107, '06:00-18:00', 'Gratis', 'Totalmente accesible', array['parque','aire-libre','familia']),
  ('a5555555-5555-5555-5555-555555555555', 'Mercado Ex Cuartel', 'gastronomia', 'Mercado de artesanías y comida típica salvadoreña', 'San Salvador', 13.6975, -89.1919, '08:00-18:00', '$5-10', 'Pasillos estrechos', array['comida-tipica','artesanias','mercado']),
  ('a6666666-6666-6666-6666-666666666666', 'Café El Mirador', 'gastronomia', 'Café con vista panorámica en Los Planes de Renderos', 'San Salvador', 13.6389, -89.1978, '08:00-17:00', '$3-5', 'Rampa en entrada principal', array['cafe','mirador','boqueron']),
  ('a7777777-7777-7777-7777-777777777777', 'Distrito de Arte de San Salvador', 'creativo', 'Zona de murales, galerías y talleres de arte urbano', 'San Salvador', 13.7014, -89.1889, '10:00-19:00', 'Gratis', 'Aceras irregulares en algunas calles', array['arte-urbano','murales','galeria']),
  ('a8888888-8888-8888-8888-888888888888', 'Casa Taller Cultural Suchitoto', 'creativo', 'Espacio de talleres de pintura, cerámica y textiles', 'Suchitoto', 13.9383, -89.0281, '09:00-16:00', '$5', 'Acceso a nivel de calle', array['taller','artesania','suchitoto']),
  ('a9999999-9999-9999-9999-999999999999', 'Iglesia El Rosario', 'cultura', 'Iglesia moderna famosa por sus vitrales y arquitectura curva', 'San Salvador', 13.6969, -89.1913, '08:00-17:00', 'Gratis', 'Totalmente accesible', array['iglesia','arquitectura','vitrales']),
  ('b1111111-1111-1111-1111-111111111111', 'Laguna de Alegría', 'eco', 'Laguna de cráter volcánico con aguas sulfurosas', 'Alegría, Usulután', 13.5044, -88.4931, '07:00-17:00', '$2', 'Sendero de tierra, terreno irregular', array['laguna','volcan','naturaleza']),
  ('b2222222-2222-2222-2222-222222222222', 'Pupusería La Ceiba', 'gastronomia', 'Pupusería tradicional con más de 20 años de tradición familiar', 'San Salvador', 13.7021, -89.2245, '11:00-21:00', '$1-3', 'Acceso a nivel de calle', array['pupusas','comida-tipica','tradicional']),
  ('b3333333-3333-3333-3333-333333333333', 'Centro Histórico de Suchitoto', 'cultura', 'Pueblo colonial con calles empedradas y casas coloridas', 'Suchitoto', 13.9381, -89.0275, '24 horas (zona publica)', 'Gratis', 'Calles empedradas, dificil en silla de ruedas', array['colonial','pueblo','arquitectura']),
  ('b4444444-4444-4444-4444-444444444444', 'Bosque Los Andes', 'eco', 'Reserva natural con senderos ecológicos y avistamiento de aves', 'San Salvador', 13.7204, -89.2650, '07:00-16:00', '$2', 'Senderos naturales, no accesible en silla de ruedas', array['bosque','aves','senderismo']),
  ('b5555555-5555-5555-5555-555555555555', 'Taller de Añil Las Chinamas', 'creativo', 'Taller de teñido tradicional con añil natural', 'San Vicente', 13.6415, -88.7833, '09:00-15:00', '$8', 'Acceso a nivel de calle', array['anil','textiles','tradicion']),
  ('b6666666-6666-6666-6666-666666666666', 'Restaurante Vista al Lago', 'gastronomia', 'Restaurante con vista al Lago de Coatepeque, cocina local e internacional', 'Coatepeque', 13.8586, -89.5406, '11:00-22:00', '$8-15', 'Rampa de acceso, terraza accesible', array['lago','cocina-local','vista'])
on conflict (id) do nothing;
 
-- -----------------------------------------
-- EVENTS (eventos turísticos)
-- -----------------------------------------
insert into events (id, nombre, fecha_hora, place_id, tipo_actividad, cupo, organizador) values
  ('c1111111-1111-1111-1111-111111111111', 'Noche de Danza Folclórica', '2026-07-12 19:00:00-06', 'a2222222-2222-2222-2222-222222222222', 'presentacion', 200, 'Teatro Nacional de San Salvador'),
  ('c2222222-2222-2222-2222-222222222222', 'Recorrido Guiado Nocturno', '2026-07-12 18:30:00-06', 'a1111111-1111-1111-1111-111111111111', 'tour-guiado', 30, 'Museo Nacional de Antropología'),
  ('c3333333-3333-3333-3333-333333333333', 'Feria de Artesanías Ex Cuartel', '2026-07-13 09:00:00-06', 'a5555555-5555-5555-5555-555555555555', 'feria', 500, 'Alcaldía de San Salvador'),
  ('c4444444-4444-4444-4444-444444444444', 'Taller de Cerámica para Principiantes', '2026-07-13 14:00:00-06', 'a8888888-8888-8888-8888-888888888888', 'taller', 15, 'Casa Taller Cultural Suchitoto'),
  ('c5555555-5555-5555-5555-555555555555', 'Amanecer en El Boquerón', '2026-07-14 05:30:00-06', 'a3333333-3333-3333-3333-333333333333', 'senderismo', 25, 'Ministerio de Turismo'),
  ('c6666666-6666-6666-6666-666666666666', 'Ruta de Murales Urbanos', '2026-07-14 16:00:00-06', 'a7777777-7777-7777-7777-777777777777', 'tour-guiado', 20, 'Colectivo Arte SV')
on conflict (id) do nothing;
 
-- -----------------------------------------
-- PROVIDERS (microemprendedores)
-- -----------------------------------------
insert into providers (id, nombre, contacto, redes_sociales, servicios, nivel_visibilidad, place_id) values
  ('d1111111-1111-1111-1111-111111111111', 'Tours Boquerón SV', '+503 7123 4567', '@toursboqueronsv', 'Tours guiados de senderismo y volcanes', 'bajo', 'a3333333-3333-3333-3333-333333333333'),
  ('d2222222-2222-2222-2222-222222222222', 'Doña Chayo Pupusas', '+503 7234 5678', '@donachayopupusas', 'Pupusas y comida típica a domicilio', 'bajo', 'b2222222-2222-2222-2222-222222222222'),
  ('d3333333-3333-3333-3333-333333333333', 'Artesanías Suchitoto Colectivo', '+503 7345 6789', '@artesaniasuchitoto', 'Venta de textiles y cerámica artesanal', 'medio', 'b3333333-3333-3333-3333-333333333333'),
  ('d4444444-4444-4444-4444-444444444444', 'Café Cultura Centro', '+503 7456 7890', '@cafeculturacentro', 'Café de especialidad y espacio cultural', 'medio', 'a7777777-7777-7777-7777-777777777777'),
  ('d5555555-5555-5555-5555-555555555555', 'Guías Locales Coatepeque', '+503 7567 8901', '@guiascoatepeque', 'Tours en lancha y pesca deportiva en el lago', 'bajo', 'b6666666-6666-6666-6666-666666666666'),
  ('d6666666-6666-6666-6666-666666666666', 'Estudio Añil Tradicional', '+503 7678 9012', '@anilsanvicente', 'Talleres de teñido con añil natural para grupos', 'alto', 'b5555555-5555-5555-5555-555555555555')
on conflict (id) do nothing;
 