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

# ------------------------- CREATE MYSQL INSTANCE ------------------------
echo
echo -e "$BLUE==>$NONE$BOLD Creating MySQL instance is started$NONE"

# Create instance
$gcloud_sdk_dir/bin/gcloud sql instances create $db_instance_name --tier=$project_sql_tier --region=$project_sql_region --project $project_id_gae --quiet --database-version MYSQL_5_7 --storage-auto-increase

# ------------------------- END CREATE MYSQL INSTANCE --------------------
