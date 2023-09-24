#!/usr/bin/env bash

docker run --rm -d --name fnbkt-proto -p 127.0.0.1:3000:8080 --link supabase_db_db-supabase:localhost --network supabase_db_db-supabase \
  --env SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0 \
  --env SUPABASE_URL=http://localhost:54321 \
  --env SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU \
  --env SUPABASE_URI=postgresql://postgres:postgres@localhost:54322/postgres \
  --env NUXT_SUPABASE_URI=postgresql://postgres:postgres@localhost:54322/postgres \
  --env NUXT_PUBLIC_SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0 \
  --env NUXT_PUBLIC_SUPABASE_URL=http://localhost:54321 \
  --env NUXT_SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU \
  --env GRAPHQL_SCHEMAS=todo,todo_api,app,app_api,msg,msg_api,inc,inc_api,loc,loc_api \
  --env NUXT_GRAPHQL_SCHEMAS=todo,todo_api,app,app_api,msg,msg_api,inc,inc_api,loc,loc_api \
  --env NUXT_GQL_HOST=http://localhost:3000/api/graphql \
  --env GQL_HOST=http://localhost:3000/api/graphql \
  fnbkt-proto



  # --env SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZudnh4Z3F1bmxxdHR0cXhqYXZjIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODkyMTEzNzIsImV4cCI6MjAwNDc4NzM3Mn0.sk0z4ZA8j1rDfbSk2zNmiDIo65mqoZYVEzruDftZRQM \
  # --env SUPABASE_URL=https://vnvxxgqunlqtttqxjavc.supabase.co \
  # --env SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZudnh4Z3F1bmxxdHR0cXhqYXZjIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODkyMTEzNzIsImV4cCI6MjAwNDc4NzM3Mn0.sk0z4ZA8j1rDfbSk2zNmiDIo65mqoZYVEzruDftZRQM \
  # --env SUPABASE_URI=postgresql://postgres:UD_z*ekEEwR9Yc7dM6T6q_hr@db.vnvxxgqunlqtttqxjavc.supabase.co:5432/postgres \
  # --env NUXT_PUBLIC_SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZudnh4Z3F1bmxxdHR0cXhqYXZjIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODkyMTEzNzIsImV4cCI6MjAwNDc4NzM3Mn0.sk0z4ZA8j1rDfbSk2zNmiDIo65mqoZYVEzruDftZRQM \
  # --env NUXT_PUBLIC_SUPABASE_URL=https://vnvxxgqunlqtttqxjavc.supabase.co \
  # --env NUXT_SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZudnh4Z3F1bmxxdHR0cXhqYXZjIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODkyMTEzNzIsImV4cCI6MjAwNDc4NzM3Mn0.sk0z4ZA8j1rDfbSk2zNmiDIo65mqoZYVEzruDftZRQM \
  # --env NUXT_SUPABASE_URI=postgresql://postgres:UD_z*ekEEwR9Yc7dM6T6q_hr@db.vnvxxgqunlqtttqxjavc.supabase.co:5432/postgres \
  # --env NUXT_SUPABASE_JWT_SECRET=DJOzjSRDSTu67+ErTYVyddjrQ2o6OLa0OV46AH1Fhi4+Kr34NGWNAR9oYiubk0pUAvv3PR2QrnItF3S6UnRfTQ== \
  # --env NUXT_RESEND_API_KEY=re_Lo7iPvN3_CAdafk9TsfJmZRQhXzYLVUyo \
  # --env NUXT_PUBLIC_GQL_HOST=https://supanuxtphile-55dlfsvaeq-uc.a.run.app/api/graphql \
  # --env NUXT_GQL_HOST=https://supanuxtphile-55dlfsvaeq-uc.a.run.app/api/graphql \
  # --env GQL_HOST=https://supanuxtphile-55dlfsvaeq-uc.a.run.app/api/graphql \
  