# Copilot Instructions for Advent of Apex 2025

## Project Overview
This is an **Advent of Code-style Salesforce project** following the CampApex.org storyline across 25 daily challenges. Each day builds automation solutions (Flows, Apex, Validation Rules, API integrations) to help a family prepare for baby's first Christmas.

## Architecture & Patterns

### Trigger Framework
- All triggers use the **TriggerHandler pattern** (see `force-app/main/default/classes/utils/TriggerHandler.cls`)
- Trigger handlers extend `TriggerHandler` and delegate business logic to service classes
- Example: `VillageTaskTrigger` → `VillageTaskTriggerHandler` → `VillageTaskService`
- Keep triggers minimal: `trigger MyTrigger on Object (events) { new MyTriggerHandler().run(); }`

### Code Organization
- **Service classes**: Business logic (e.g., `VillageTaskService.handleBeforeInsert()`)
- **Utils classes**: Reusable helper methods (e.g., `VillageTaskUtils.isValidDelete()`)
- **Test classes**: Located in `tests/` subdirectories with descriptive method names
- **Integration tests**: Separate classes for end-to-end scenarios

### Custom Objects & Namespacing
- All custom objects use `CAMPX__` namespace prefix
- Primary objects: `CAMPX__Village_Task__c`, `CAMPX__Family_Support_Plan__c`
- Key fields: `CAMPX__Support_Phase__c`, `CAMPX__Is_Baby_Safety_Critical__c`, `CAMPX__Status__c`

## Development Workflow

### Daily Challenge Pattern
1. Work on `day-XX` branches (e.g., `day-4` for Day 4)
2. Each challenge documented in `documentation/days/DayXX.md`
3. Solution details in `documentation/days/solutions/DayXX_Solution.md`
4. Say "complete day" to auto-trigger solution documentation
5. Merge to `main` after completion

### Key Commands
```bash
# Deploy to org
npm run deploy:xml

# Run tests with coverage
npm run test:unit:coverage

# Format code (includes Apex, LWC, metadata)
npm run prettier

# Lint LWC components
npm run lint
```

### AI Agent Triggers
User can say any of these to trigger solution documentation:
- "complete day" / "finish day" / "complete challenge"
- "document solution" / "document day"
- Agent auto-detects day from branch name or solution files

### Testing Standards
- Use descriptive test method names: `test_methodName_scenario`
- Bulkified testing: Test both single records and collections
- Custom assertion messages with context: `System.assert(condition, 'CONTEXT:\nDetails')`
- Test error scenarios explicitly (e.g., validation rule failures)

## Business Context

### Story Elements
- **Characters**: Grandma Kelly, Dr. Grace Evergreen, Monica McPatchwork, etc.
- **Phases**: "Before Baby Arrives", "Baby's First Days", "Ongoing Support"
- **Safety-critical tasks**: Cannot be deleted unless completed (see `VillageTaskUtils.isValidDelete()`)

### Key Business Rules
- Pre-arrival tasks auto-get 14-day due dates if blank
- Safety-critical incomplete tasks cannot be deleted
- Character assignment flows trigger based on task types

## Code Quality Standards
- **Separation of concerns**: Triggers → Handlers → Services → Utils
- **Bulkification**: All operations handle collections
- **Error handling**: Use `addError()` for validation failures
- **Documentation**: JSDoc-style comments with `@description`, `@param`, `@return`
- **Formatting**: Prettier handles all file types including Apex

## Solution Documentation Standards

### Daily Challenge Completion Workflow
When user says "complete day" (or variations like "finish day", "complete challenge", "document solution"):

**Auto-detect day number from:**
1. Current branch name (`day-4` → Day 4)
2. OR lowest numbered solution file with placeholder content

**Pre-execution checks:**
- ❌ **Abort if on `main` branch**: "Cannot complete day on main branch. Switch to day-XX branch first."
- ❌ **Abort if solution already complete**: "Day X solution appears already documented. Check `documentation/days/solutions/DayX_Solution.md`"
- ⚠️ **Confirm if Apex added without tests**: Check for new .cls files without corresponding test coverage (new _Test.cls files or new test methods in existing test files) and ask user to confirm proceeding

**Execution sequence:**
1. **Update Solution File**: `documentation/days/solutions/DayX_Solution.md`
2. **Stage Changes**: `git add .`
3. **Commit**: Generate descriptive commit message starting with "Day X Solution:"
4. **Push with Upstream**: `git push -u origin day-X` (always use -u to set upstream tracking)
5. **Summary Report**: Display status summary:
   ```
   Commit: [success|fail]
   Push: [success|fail]  
   Message: [commit message]
   ```
6. **PR Confirmation**: Ask user "Create pull request to main?" Upon confirmation, open PR with title "Day X Solution" and commit message as body

### Solution Documentation Structure
Each solution file must follow this **exact format** (reference Day1-3 solutions as examples):

#### Required Sections:
1. **Approach / Solution Notes**: High-level strategy chosen (Flow vs Apex, why this approach)
2. **Relevant Apex, Flow, or Metadata Details**: 
   - Implementation specifics (class names, flow names, trigger events)
   - Code snippets for key logic
   - Configuration details (filters, field mappings, etc.)
3. **Test Summaries**: Bulleted checklist format with ✅ for completed test scenarios
4. **Lessons Learned**: Numbered insights about patterns, performance, best practices

#### Documentation Patterns:
- **Technical Detail Level**: Include API names, class methods, field API names
- **Code Examples**: Show key business logic inline with triple backticks
- **Validation Rules**: Clearly state what can/cannot be done
- **Bulk Operation Notes**: Always mention how solution handles bulk processing
- **Framework References**: When using TriggerHandler, mention the delegation pattern
- **Test Coverage**: List test classes and key scenarios validated

#### Writing Style:
- Use past tense ("I chose", "The Flow successfully handles")
- Include exact class/flow/field names with proper formatting
- Bullet points with checkmarks for test summaries
- Numbered lists for lessons learned
- Technical accuracy over brevity

## File Structure Notes
- Source code: `force-app/main/default/`
- Utils in subdirectories: `classes/utils/`, `classes/tests/`
- Daily solutions: `documentation/days/solutions/DayXX_Solution.md`
- Deployment manifest: `manifests/package.xml`
- Scratch org config: `config/project-scratch-def.json`