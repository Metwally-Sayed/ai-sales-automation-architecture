workspace "AI Sales Automation Platform" "Architecture model for the MVP" {

    model {
        customer = person "Customer" "Sends messages to the business"
        employee = person "Sales employee" "Reviews leads, tasks, and AI drafts"
        owner = person "Business owner" "Reads reports and sales summaries"

        whatsapp = softwareSystem "WhatsApp Web" "Customer conversations on WhatsApp"
        meta = softwareSystem "Meta Business Suite" "Instagram and Facebook inboxes"
        openai = softwareSystem "OpenAI" "Language models used by Hermes"
        browserbase = softwareSystem "Browserbase" "Managed browser sessions for Meta inbox access"

        platform = softwareSystem "AI Sales Automation Platform" "Captures conversations, manages leads, and runs controlled AI automation" {
            whatsappConnector = container "WhatsApp Connector" "Reads and sends WhatsApp messages through a provider adapter" "OpenWA / WPPConnect / whatsapp-web.js"
            metaWorker = container "Meta Browser Worker" "Reads and sends Instagram and Facebook messages through the browser" "Browserbase + Playwright + Stagehand"
            gateway = container "Channel Gateway" "Normalizes messages, checks duplicates, and routes outbound commands" "NestJS module"
            core = container "Core Application" "Owns contacts, conversations, leads, tasks, approvals, outbox, reports, and tenant rules" "NestJS modular monolith"
            hermes = container "Hermes Agent Runtime" "Runs AI tasks and calls restricted backend tools" "Hermes"
            jobs = container "Background Workers" "Runs message jobs, retries, and scheduled follow-ups" "BullMQ"
            database = container "Main Database" "Source of truth for business data and audit records" "PostgreSQL" "Database"
            redis = container "Queue and Cache" "Jobs, locks, retries, and delayed work" "Redis" "Database"
            files = container "File Storage" "Message attachments and company knowledge files" "MinIO / S3-compatible" "Database"
        }

        customer -> whatsapp "Sends WhatsApp message"
        customer -> meta "Sends Instagram or Facebook message"

        whatsapp -> whatsappConnector "Message appears in WhatsApp Web"
        meta -> metaWorker "Message appears in Meta inbox"
        browserbase -> metaWorker "Provides isolated browser session"

        whatsappConnector -> gateway "Sends raw message event"
        metaWorker -> gateway "Sends raw message event"
        gateway -> jobs "Queues normalized work"
        jobs -> core "Processes message and updates CRM data"

        core -> hermes "Requests classification, extraction, draft, or follow-up plan"
        hermes -> openai "Runs model task"
        hermes -> core "Calls restricted tools or returns proposed actions"

        employee -> core "Reviews leads and approves AI actions"
        owner -> core "Reads reports and daily summaries"

        core -> database "Reads and writes business data"
        jobs -> redis "Uses queues and locks"
        core -> files "Stores and reads attachments"

        core -> jobs "Queues outbound message"
        jobs -> gateway "Runs outbound send job"
        gateway -> whatsappConnector "Routes WhatsApp command"
        gateway -> metaWorker "Routes Meta command"
        whatsappConnector -> whatsapp "Sends approved reply"
        metaWorker -> meta "Sends approved reply"
    }

    views {
        systemContext platform "SystemContext" {
            include *
            autoLayout lr
            title "System Context"
            description "Who uses the platform and which external systems it connects to"
        }

        container platform "Containers" {
            include *
            autoLayout lr
            title "Container Architecture"
            description "The main runtime parts of the MVP"
        }

        styles {
            element "Person" {
                shape Person
                background #08427B
                color #FFFFFF
            }
            element "Software System" {
                background #1168BD
                color #FFFFFF
            }
            element "Container" {
                background #438DD5
                color #FFFFFF
            }
            element "Database" {
                shape Cylinder
                background #2E7D32
                color #FFFFFF
            }
        }
    }
}
