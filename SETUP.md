# Setup Guide - Upwork Automation Workflow

## Step-by-Step Installation

### 1. Prerequisites Installation

#### Docker Installation
- **Windows**: Download Docker Desktop from https://www.docker.com/products/docker-desktop
- **Mac**: Download Docker Desktop from https://www.docker.com/products/docker-desktop
- **Linux**: 
  ```bash
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  ```

#### Verify Docker Installation
```bash
docker --version
docker-compose --version
```

### 2. Project Setup

```bash
# Clone or download the project
cd Assignment2

# Copy configuration template
cp config.template.env .env

# Edit .env file with your credentials
# Use your preferred text editor
```

### 3. API Credentials Setup

#### Apify API Token
1. Go to https://console.apify.com/
2. Sign up or log in
3. Navigate to Settings → Integrations
4. Copy your API token
5. Paste in `.env` file: `APIFY_API_TOKEN=your_token_here`

#### OpenAI API Key
1. Go to https://platform.openai.com/
2. Sign up or log in
3. Navigate to API Keys section
4. Create a new API key
5. Copy the key (starts with `sk-`)
6. Paste in `.env` file: `OPENAI_API_KEY=sk-your_key_here`

#### Airtable Setup
1. Go to https://airtable.com/
2. Create a new base or use existing
3. Create a table with these fields:
   - `Job Title` (Single line text)
   - `Job Description` (Long text)
   - `Score` (Number)
   - `Priority` (Single select: High, Medium, Low)
   - `Reasoning` (Long text)
   - `Budget` (Number)
   - `Experience Level` (Single line text)
   - `Job URL` (URL)
   - `Matched Skills` (Single line text)
   - `Posted Date` (Date)
   - `Processed At` (Date)
4. Get API token: https://airtable.com/create/tokens
5. Get Base ID from URL: `https://airtable.com/YOUR_BASE_ID/...`
6. Get Table ID from table settings
7. Update `.env` file with all three values

#### Slack Webhook (Optional)
1. Go to https://api.slack.com/apps
2. Create a new app or use existing
3. Enable Incoming Webhooks
4. Create a webhook for your channel
5. Copy webhook URL
6. Paste in `.env` file: `SLACK_WEBHOOK_URL=your_webhook_url`

### 4. Start n8n

```bash
# Start n8n container
docker-compose up -d

# Check if it's running
docker-compose ps

# View logs
docker-compose logs -f n8n
```

### 5. Access n8n Interface

1. Open browser: http://localhost:5678
2. Login with credentials from `.env`:
   - Username: `admin` (or your `N8N_USER`)
   - Password: (your `N8N_PASSWORD`)

### 6. Import Workflow

1. In n8n, click "Workflows" in left sidebar
2. Click "Import from File" button
3. Select `Upwork-Automation.json`
4. Workflow will appear in your list

### 7. Configure Credentials in n8n

#### Apify Credentials
1. Go to Settings → Credentials
2. Click "Add Credential"
3. Search for "HTTP Header Auth"
4. Name: "Apify API"
5. Header Name: `Authorization`
6. Header Value: `Bearer YOUR_APIFY_TOKEN`
7. Save

#### OpenAI Credentials
1. Go to Settings → Credentials
2. Click "Add Credential"
3. Search for "OpenAI"
4. Name: "OpenAI API"
5. API Key: (your OpenAI key)
6. Save

#### Airtable Credentials
1. Go to Settings → Credentials
2. Click "Add Credential"
3. Search for "Airtable"
4. Name: "Airtable API"
5. API Token: (your Airtable token)
6. Save

#### Slack Credentials (if using)
1. Go to Settings → Credentials
2. Click "Add Credential"
3. Search for "HTTP Header Auth"
4. Name: "Slack Webhook"
5. Leave headers empty (webhook URL is in node)
6. Save

### 8. Update Workflow Nodes

1. Open the imported workflow
2. Update each node's credentials:
   - **Fetch Upwork Jobs (Apify)**: Select "Apify API" credential
   - **AI Score Job (GPT-4o)**: Select "OpenAI API" credential
   - **Create Airtable Records**: Select "Airtable API" credential
   - **Send Slack Alert**: Select "Slack Webhook" credential (if using)

3. Update environment variables in nodes:
   - Check nodes that use `$env.AIRTABLE_BASE_ID` and `$env.AIRTABLE_TABLE_ID`
   - These should be set in `.env` file

### 9. Test Workflow

1. Click "Execute Workflow" button
2. Watch execution in real-time
3. Check each node for errors
4. Verify data appears in Airtable

### 10. Activate Scheduled Execution

1. Ensure "Schedule Trigger" node is enabled
2. Toggle "Active" switch at top of workflow
3. Workflow will run automatically every 8 hours

## Verification Checklist

- [ ] Docker containers are running
- [ ] n8n is accessible at http://localhost:5678
- [ ] Workflow is imported successfully
- [ ] All credentials are configured
- [ ] Environment variables are set in `.env`
- [ ] Airtable table has all required fields
- [ ] Manual execution completes without errors
- [ ] Data appears in Airtable
- [ ] Slack alerts work (if configured)
- [ ] Scheduled trigger is active

## Troubleshooting

### Container won't start
```bash
# Check logs
docker-compose logs n8n

# Restart container
docker-compose restart n8n

# Rebuild if needed
docker-compose up -d --build
```

### Can't access n8n
- Verify port 5678 is not in use
- Check firewall settings
- Try http://127.0.0.1:5678 instead

### Workflow execution fails
- Check execution log in n8n
- Verify all credentials are correct
- Check API keys have sufficient credits
- Review error messages in failed nodes

### No data in Airtable
- Verify Base ID and Table ID are correct
- Check field names match exactly
- Ensure API token has write permissions
- Check Airtable table structure

## Next Steps

1. Review the workflow execution logs
2. Adjust skill weights if needed
3. Fine-tune pre-filtering criteria
4. Monitor for at least 24 hours
5. Collect sample scored jobs for report
