-- +goose Up
-- A user may hold independent active grants for different sessions in the
-- same project, while retaining at most one active grant per exact scope.
DROP INDEX IF EXISTS ao_project_share_grants_one_active;
CREATE UNIQUE INDEX ao_project_share_grants_project_scope_one_active
    ON ao_project_share_grants(user_id, org_id, project_id)
    WHERE status = 'active' AND session_id IS NULL;
CREATE UNIQUE INDEX ao_project_share_grants_session_scope_one_active
    ON ao_project_share_grants(user_id, org_id, project_id, session_id)
    WHERE status = 'active' AND session_id IS NOT NULL;

-- +goose Down
DROP INDEX IF EXISTS ao_project_share_grants_project_scope_one_active;
DROP INDEX IF EXISTS ao_project_share_grants_session_scope_one_active;
CREATE UNIQUE INDEX ao_project_share_grants_one_active
    ON ao_project_share_grants(user_id, org_id, project_id)
    WHERE status = 'active';
