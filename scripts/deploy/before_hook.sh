#!/bin/bash
#
# Copyright 2018 Google Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ ! -z $hook_executed ]; then
  return
fi

hook_executed=1

# Set DB connection variables.
cloudsql_dir=/tmp/cloudsql
cloud_db_uri="mysql+mysqldb://$db_username:$db_password@/$db_name?unix_socket=/cloudsql/$db_instance_conn_name"
local_db_uri="mysql+mysqldb://$db_username:$db_password@/$db_name?unix_socket=$cloudsql_dir/$db_instance_conn_name"

# Show Deploy Variables
echo "Specified stage: ${stage}"
echo "Current dir: $(pwd)"
echo "Workdir: $workdir"

# Copy source code to the working directory.
if [ -x "$(command -v rsync)" ]; then
  rsync -r --exclude=.git --exclude=.idea --exclude='*.pyc' \
    --exclude=frontend/node_modules --exclude=backends/data/*.json . $workdir
fi

# Create DB config for App Engine application in the cloud.
echo "SQLALCHEMY_DATABASE_URI=\"$cloud_db_uri\"" > $workdir/backends/instance/config.py

# Copy service account file for deployment.
cp backends/data/$service_account_file $workdir/backends/data/service-account.json
rm -f $workdir/backends/data/service-account.json.*

# Make app_data.json for backends.
cat > $workdir/backends/data/app.json <<EOL
{
  "notification_sender_email": "$notification_sender_email",
  "app_title": "$app_title"
}
EOL

# Make environment.prod.ts for frontend
cat > $workdir/frontend/src/environments/environment.prod.ts <<EOL
export const environment = {
  production: true,
  app_title: "$app_title",
  enabled_stages: $enabled_stages
}
EOL
