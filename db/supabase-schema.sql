-- ============================================================
--  ESQUEMA DE BASE DE DATOS · Dashboard Ejecutivo Odoo Factura
--  Ejecuta TODO este script una sola vez en:
--    Supabase → SQL Editor → New query → pega esto → Run
-- ============================================================

-- Tabla: un documento JSON por usuario con todo su dashboard
create table if not exists public.dashboards (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Seguridad a nivel de fila (RLS): cada quien solo ve y edita SU dashboard
alter table public.dashboards enable row level security;

-- (Re)crea las políticas
drop policy if exists "dashboards_select_own" on public.dashboards;
drop policy if exists "dashboards_insert_own" on public.dashboards;
drop policy if exists "dashboards_update_own" on public.dashboards;
drop policy if exists "dashboards_delete_own" on public.dashboards;

create policy "dashboards_select_own"
  on public.dashboards for select
  using (auth.uid() = user_id);

create policy "dashboards_insert_own"
  on public.dashboards for insert
  with check (auth.uid() = user_id);

create policy "dashboards_update_own"
  on public.dashboards for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "dashboards_delete_own"
  on public.dashboards for delete
  using (auth.uid() = user_id);

-- Listo. La app crea/actualiza la fila automáticamente al usarla.
