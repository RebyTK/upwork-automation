# Upwork Automation Workflow - Enhanced

A production-ready n8n workflow that automates Upwork job discovery, AI-powered scoring, and lead management using Apify, OpenAI GPT-4o, and Airtable.

## 🎯 Features

- **Automated Job Discovery**: Fetches Upwork jobs every 8 hours using Apify API
- **Time-based Filtering**: Only processes jobs posted within the last 6 hours
- **AI-Powered Scoring**: Uses OpenAI GPT-4o to score jobs (1-10) with detailed reasoning
- **Priority Classification**: Automatically classifies jobs as High/Medium/Low priority
- **Skill-Based Scoring**: Custom skill weights for enhanced accuracy
- **Pre-filtering**: Filters jobs by budget and experience level before AI scoring
- **Airtable Integration**: Pushes all qualified leads to Airtable for proposal management
- **Slack Alerts**: Real-time notifications for high-priority jobs
- **Error Handling**: Comprehensive error handling and logging

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- API keys for:
  - [Apify](https://console.apify.com/account/integrations)
  - [OpenAI](https://platform.openai.com/api-keys)
  - [Airtable](https://airtable.com/create/tokens)
  - [Slack Webhook](https://api.slack.com/messaging/webhooks) (optional)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Assignment2
   ```

2. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your API keys and credentials
   ```

3. **Start n8n with Docker Compose**
   ```bash
   docker-compose up -d
   ```

4. **Access n8n**
   - Open your browser and navigate to `http://localhost:5678`
   - Login with credentials from `.env` file (default: admin/changeme)

5. **Import the workflow**
   - Click on "Workflows" in the left sidebar
   - Click "Import from File"
   - Select `Upwork-Automation.json`
   - The workflow will be imported with all nodes

6. **Configure credentials in n8n**
   - Go to Settings → Credentials
   - Create the following credentials:
     - **Apify API**: HTTP Header Auth with `Authorization: Bearer YOUR_APIFY_TOKEN`
     - **OpenAI API**: API Key with your OpenAI key
     - **Airtable API**: API Token with your Airtable token
     - **Slack Webhook**: HTTP Header Auth (if using Slack alerts)

7. **Set up Airtable Base**
   - Create a new Airtable base or use an existing one
   - Create a table with the following fields:
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
   - Copy your Base ID and Table ID from the Airtable URL
   - Update `.env` file with these IDs

8. **Activate the workflow**
   - Open the imported workflow
   - Click "Active" toggle to enable it
   - The workflow will run automatically every 8 hours

## 📋 Workflow Architecture

```
Schedule Trigger (Every 8h)
    ↓
Fetch Upwork Jobs (Apify API)
    ↓
Filter Recent Jobs (Last 6h + Pre-filter)
    ↓
Set Skill Weights
    ↓
AI Score Job (GPT-4o)
    ↓
Enhance with Skill-Based Scoring
    ↓
    ├─→ Filter High Priority Jobs
    │       ↓
    │   Create Airtable Records (High Priority)
    │       ↓
    │   Send Slack Alert
    │
    └─→ Create Airtable Records (All)
            ↓
        Error Handling & Logging
```

## 🔧 Configuration

### Skill Weights

Edit the "Set Skill Weights" node to customize skill importance:
- `n8n`: 3.0
- `AI workflow`: 3.0
- `automation`: 2.0
- `Twilio`: 2.0
- `Retell`: 2.0
- `conversational automation`: 3.0

### Pre-filtering Settings

In the "Filter Recent Jobs" node, you can adjust:
- **Minimum Budget**: Default $500 (set `minBudget` variable)
- **Experience Levels**: Default `['intermediate', 'expert']` (set `allowedLevels` array)

### Scoring Algorithm

Final score combines:
- **AI Score (70%)**: GPT-4o analysis
- **Skill Score (30%)**: Keyword-based matching with weights

Priority classification:
- **High**: Score 8-10
- **Medium**: Score 5-7
- **Low**: Score 1-4

## 🧪 Testing

### Manual Execution

1. Open the workflow in n8n
2. Click "Execute Workflow" button
3. Monitor execution in the execution log
4. Verify data in Airtable

### Validation Checklist

- [ ] Apify successfully fetches job data
- [ ] Jobs are filtered to last 6 hours only
- [ ] OpenAI returns valid JSON with score, priority, and reasoning
- [ ] Airtable records are created with all required fields
- [ ] High-priority jobs trigger Slack alerts
- [ ] Error handling logs failures appropriately
- [ ] At least 10 qualified jobs are processed successfully

## 📊 Expected Output

Each processed job will have:
- **Job Title**: From Upwork listing
- **Job Description**: Full description text
- **Score**: 1-10 (combined AI + skill score)
- **Priority**: High/Medium/Low
- **Reasoning**: Detailed explanation from AI
- **Matched Skills**: List of relevant skills found
- **Budget**: Job budget or hourly rate
- **Experience Level**: Required experience
- **Job URL**: Direct link to Upwork job
- **Posted Date**: When job was posted
- **Processed At**: When workflow processed it

## 🐛 Troubleshooting

### Common Issues

1. **Apify API Errors**
   - Verify API token is correct
   - Check Apify account has sufficient credits
   - Ensure actor is available: `neatrat~upwork-job-scraper`
   - Note: The workflow uses the `neatrat~upwork-job-scraper` actor which filters jobs by `maxJobAge` (6 hours) in the request

2. **OpenAI API Errors**
   - Verify API key is valid
   - Check account has sufficient credits
   - Monitor rate limits (requests per minute)

3. **Airtable Errors**
   - Verify Base ID and Table ID are correct
   - Ensure all required fields exist in Airtable
   - Check API token permissions

4. **No Jobs Found**
   - Verify search query in Apify node
   - Check time filter (6 hours) isn't too restrictive
   - Adjust pre-filtering criteria if too strict

5. **Slack Alerts Not Working**
   - Verify webhook URL is correct
   - Test webhook manually with curl
   - Check Slack app permissions

### Debug Mode

Enable detailed logging:
1. Set `N8N_LOG_LEVEL=debug` in `.env`
2. Restart Docker container
3. Check logs: `docker-compose logs -f n8n`

## 🔒 Security Best Practices

- Never commit `.env` file to version control
- Use strong passwords for n8n basic auth
- Rotate API keys regularly
- Limit n8n access to trusted networks
- Use environment variables for all secrets
- Enable HTTPS in production (use reverse proxy)

## 📈 Monitoring

### Execution History

- View all executions in n8n UI
- Check success/failure rates
- Monitor execution times

### Metrics

- Jobs processed per run
- Average score distribution
- High-priority job frequency
- Error rate

## 🚀 Production Deployment

### Recommended Setup

1. **Use Docker Compose in production**
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

2. **Set up reverse proxy** (nginx/traefik)
   - Enable HTTPS
   - Configure domain name
   - Set up SSL certificates

3. **Backup strategy**
   - Regular backups of n8n data volume
   - Export workflow JSON files
   - Backup Airtable data

4. **Monitoring**
   - Set up health checks
   - Configure alerting for failures
   - Monitor API rate limits

## 📝 License

This project is provided as-is for educational and assessment purposes.

## 🤝 Support

For issues or questions:
1. Check the troubleshooting section
2. Review n8n documentation: https://docs.n8n.io
3. Check execution logs in n8n UI

---

**Assignment Deliverables:**
- ✅ Updated n8n workflow JSON
- ✅ Docker setup files
- ✅ Configuration templates
- ✅ Setup documentation
- ✅ Error handling and logging
- ✅ Enhanced features (Slack alerts, skill-based scoring, pre-filtering)
