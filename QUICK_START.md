# Quick Start Guide

Get up and running in 5 minutes!

## Prerequisites
- Docker installed
- API keys ready (Apify, OpenAI, Airtable)

## Steps

1. **Clone and configure**
   ```bash
   cd Assignment2
   cp config.template.env .env
   # Edit .env with your API keys
   ```

2. **Start n8n**
   ```bash
   docker-compose up -d
   ```

3. **Access n8n**
   - Open http://localhost:5678
   - Login (default: admin/changeme)

4. **Import workflow**
   - Workflows → Import from File
   - Select `Upwork-Automation.json`

5. **Configure credentials**
   - Settings → Credentials
   - Add: Apify API, OpenAI API, Airtable API, Slack Webhook

6. **Set up Airtable**
   - Create table with fields from README.md
   - Copy Base ID and Table ID to .env

7. **Test**
   - Open workflow → Execute Workflow
   - Check Airtable for results

8. **Activate**
   - Toggle "Active" switch
   - Runs every 8 hours automatically

## Troubleshooting

**Container won't start?**
```bash
docker-compose logs n8n
```

**Workflow fails?**
- Check execution log in n8n
- Verify all credentials are set
- Check API keys have credits

**Need help?**
- See SETUP.md for detailed instructions
- Check README.md for full documentation
