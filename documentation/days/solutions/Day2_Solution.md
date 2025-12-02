# Day 2 Solution - Task Auto-Assignment by Type

## Approach / Solution Notes
I chose to implement this challenge using a Record-Triggered Flow with a Before Save trigger. This declarative approach automatically assigns Village Tasks to the appropriate villager based on Task Type without requiring manual intervention. The Flow uses a decision element to evaluate Task Type values and assign the corresponding character while respecting any existing manual assignments.

## Relevant Apex, Flow, or Metadata Details
**Flow Name:** Village Task - Assign Character
**Type:** Auto-Launched Flow (Record-Triggered)
**API Version:** 65.0

### Trigger Configuration:
- **Object:** CAMPX__Village_Task__c
- **Trigger Type:** RecordBeforeSave (Before Insert)
- **Filter Logic:** AND condition
- **Filters:**
  - Task Type is not null
  - Assigned Character is null (prevents overwriting manual assignments)

### Character Assignment Logic:
The Flow uses a decision element with the following Task Type to Character mappings:
- **"Cook / Deliver Meal"** → "Ginger Claus"
- **"Build / Fix"** → "Stella Pinewood"  
- **"Health & Safety Check"** → "Dr. Grace Evergreen"
- **"Decorate"** → "Poppy Wintergold"
- **"Garden / Outdoor"** → "Ivy Evergreen"

### Flow Elements:
1. **Start Element:** Configured with filters to only process records with populated Task Type and blank Assigned Character
2. **Decision Element:** Evaluates Task Type field with 5 outcome paths for supported types
3. **Assignment Elements:** 5 separate assignment elements that set the Assigned Character field value

## Test Summaries
The Flow successfully handles the automation requirements:
- ✅ Triggers only on Village Task insert (before save)
- ✅ Applies correct filtering logic (Task Type populated AND Assigned Character blank)
- ✅ Assigns correct character for each supported Task Type
- ✅ Preserves existing manual character assignments
- ✅ Ignores unsupported Task Types (leaves Assigned Character blank)
- ✅ Handles bulk operations (Flow processes records individually but supports bulk DML)

## Lessons Learned
1. **Before Save vs. After Save:** Using Before Save trigger allows field assignment without additional DML operations, improving performance
2. **Filter Optimization:** Proper start filters ensure the automation only runs when necessary and respects existing data
3. **Decision Logic:** Multiple outcome decision elements cleanly handle complex conditional assignments
4. **Manual Override Respect:** Checking for blank Assigned Character ensures users can still manually assign tasks when needed
5. **Bulk Processing:** Record-Triggered Flows automatically handle bulk operations efficiently through Salesforce's flow engine
6. **Exact String Matching:** Flow decision elements require exact string matching for Task Type values - any variations in spacing or capitalization would cause assignment failures
7. **Flow Naming Conventions:** Descriptive flow names following organizational standards (Object - Action pattern) improve maintainability and team collaboration
8. **Entry Criteria Optimization:** Using entry criteria to filter records before flow execution improves performance and prevents unnecessary processing