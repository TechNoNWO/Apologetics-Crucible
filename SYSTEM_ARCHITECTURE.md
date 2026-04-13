# Complete System Architecture - End-to-End Flow
## UI → API → Database → API → UI

---

## 🔄 Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           FRONTEND LAYER (Angular 18+)                       │
│                          localhost:4200 (Browser)                            │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │                  Ingestion Preview Grid Component                     │  │
│  │                                                                       │  │
│  │  1. User opens http://localhost:4200                               │  │
│  │  2. Component initializes → ngOnInit()                             │  │
│  │  3. Calls IngestionApiService.getIngestionPreview()               │  │
│  │                                                                     │  │
│  │  ┌────────────────────────────────────────────────────────────┐  │  │
│  │  │ Table Display                                               │  │  │
│  │  │ ┌──┬─────────┬────────┬────────────┬─────────────┐        │  │  │
│  │  │ │ID│ Blurb  │Strength│Association│Proposition  │        │  │  │
│  │  │ ├──┼────────┴────────┴────────────┴─────────────┤        │  │  │
│  │  │ │ 1│ [Data from Database Row 1]                 │        │  │  │
│  │  │ │ 2│ [Data from Database Row 2]                 │        │  │  │
│  │  │ │ 3│ [Data from Database Row 3]                 │        │  │  │
│  │  │ └──┴──────────────────────────────────────────────┘        │  │  │
│  │  │                                                             │  │  │
│  │  │ [Edit] [Commit All to Nodes]                              │  │  │
│  │  └────────────────────────────────────────────────────────────┘  │  │
│  │                                                                       │  │
│  │  User Actions:                                                       │  │
│  │  - Click cell → Edit inline                                         │  │
│  │  - Click ✓ → Send PUT to API                                        │  │
│  │  - Click "Commit All" → Send POST to API                           │  │
│  │                                                                       │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                                                              │
│  Angular Signals (Reactive State)                                           │
│  ├── rows = signal<IngestionPreviewRow[]>([])                              │
│  ├── isLoading = signal(false)                                             │
│  ├── error = signal<string | null>(null)                                   │
│  ├── editingRowId = signal<string | number | null>(null)                  │
│  └── editingField = signal<string | null>(null)                            │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                    ↓
                            HTTP REQUEST (CORS enabled)
                                    ↓
                    GET /api/ingestion-preview
                    PUT /api/ingestion-preview/{id}
                    POST /api/ingestion-preview
                                    ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                      API LAYER (Spring Boot 3.3.4)                          │
│                        localhost:8080 (Backend)                             │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │           IngestionPreviewController (Thin Orchestration)            │  │
│  │                                                                       │  │
│  │  @GetMapping                                                         │  │
│  │  public Map<String, Object> getPreview()                           │  │
│  │  {                                                                   │  │
│  │    1. Receive GET request                                           │  │
│  │    2. Log: "GET /api/ingestion-preview"                            │  │
│  │    3. Initialize JdbcTemplate query                                │  │
│  │  }                                                                   │  │
│  │                                                                       │  │
│  │  @PutMapping("/{id}")                                              │  │
│  │  public Map<String, Object> updateField(...)                      │  │
│  │  {                                                                   │  │
│  │    1. Receive PUT request with field name/value                    │  │
│  │    2. Log: "PUT /api/ingestion-preview/{id}"                       │  │
│  │    3. Validate field name (prevent SQL injection)                  │  │
│  │    4. Build UPDATE SQL with field name                            │  │
│  │  }                                                                   │  │
│  │                                                                       │  │
│  │  @PostMapping                                                       │  │
│  │  public Map<String, Object> commitPreview(...)                    │  │
│  │  {                                                                   │  │
│  │    1. Receive POST request with commit data                        │  │
│  │    2. Log: "POST /api/ingestion-preview - COMMIT"                 │  │
│  │    3. Execute database commit operation                            │  │
│  │  }                                                                   │  │
│  │                                                                       │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                                                              │
│  @RestController + @CrossOrigin enabled                                     │
│  ├── CORS Headers configured                                               │
│  ├── Content-Type: application/json                                        │
│  ├── All requests logged with SLF4J                                        │
│  └── Error handling with detailed messages                                 │
│                                                                              │
│  Dependency Injection:                                                       │
│  └── private final JdbcTemplate jdbcTemplate                               │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                    ↓
                        JdbcTemplate Query Execution
                                    ↓
        SELECT * FROM IngestionPreview
        UPDATE IngestionPreview SET field = value
        (Future: EXEC sp_CommitIngestionPreview)
                                    ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                    DATABASE LAYER (SQL Server 2019)                         │
│                   localhost:1433 (Database Server)                          │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │                    IngestionPreview Table                             │  │
│  │                                                                       │  │
│  │  Schema:                                                             │  │
│  │  ┌────────────────────────────────────────────────────────────────┐│  │
│  │  │ Column              │ Type              │ Description          ││  │
│  │  ├────────────────────┼──────────────────┼──────────────────────┤│  │
│  │  │ id                 │ INT PRIMARY KEY  │ Record identifier    ││  │
│  │  │ sourceText         │ NVARCHAR(MAX)    │ Original source text ││  │
│  │  │ blurb              │ NVARCHAR(MAX)    │ Summary/description  ││  │
│  │  │ suggestedStrength  │ NVARCHAR(50)     │ Strong/Moderate/Weak││  │
│  │  │ associationType    │ NVARCHAR(100)    │ Relationship type    ││  │
│  │  │ propositionId      │ INT              │ Linked proposition   ││  │
│  │  └────────────────────────────────────────────────────────────────┘│  │
│  │                                                                       │  │
│  │  Sample Data:                                                        │  │
│  │  ┌─────┬──────────────────┬───────────┬────────────┬────────────┐   │  │
│  │  │ id  │ sourceText       │ blurb     │ strength   │ type       │   │  │
│  │  ├─────┼──────────────────┼───────────┼────────────┼────────────┤   │  │
│  │  │ 1   │ "Genesis 1:1"    │ "Creation"│ "Strong"   │ "Direct"   │   │  │
│  │  │ 2   │ "John 3:16"      │ "Love"    │ "Strong"   │ "Direct"   │   │  │
│  │  │ 3   │ "Psalm 23:1"     │ "Trust"   │ "Moderate" │ "Metaphor" │   │  │
│  │  └─────┴──────────────────┴───────────┴────────────┴────────────┘   │  │
│  │                                                                       │  │
│  │  Operations:                                                         │  │
│  │  1. READ (SELECT) - Frontend requests data                         │  │
│  │  2. UPDATE - User edits field inline                               │  │
│  │  3. COMMIT - All changes persisted                                 │  │
│  │                                                                       │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                                                              │
│  Future: Stored Procedures (Business Logic)                                 │
│  ├── sp_ParseSourceForIngestion                                            │
│  └── sp_CommitIngestionPreview                                             │
│                                                                              │
│  Connection Pool:                                                            │
│  ├── Driver: com.microsoft.sqlserver.jdbc.SQLServerDriver                  │
│  ├── URL: jdbc:sqlserver://localhost:1433;databaseName=ApologeticsCrucible │
│  ├── Username: sa                                                          │
│  └── Encrypt: true, TrustServerCertificate: true                          │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                    ↑
                        Database Results (Result Set)
                                    ↑
        List<Map<String, Object>> rows
                                    ↑
┌─────────────────────────────────────────────────────────────────────────────┐
│                      API LAYER (Response)                                   │
│                                                                              │
│  Response Serialization:                                                     │
│  Map<String, Object> → JSON                                                │
│                                                                              │
│  Success Response:                                                           │
│  {                                                                           │
│    "status": "success",                                                    │
│    "data": [                                                               │
│      { "id": 1, "sourceText": "...", "blurb": "...", ... },             │
│      { "id": 2, "sourceText": "...", "blurb": "...", ... }              │
│    ],                                                                       │
│    "count": 2,                                                             │
│    "message": "Retrieved 2 records from database"                         │
│  }                                                                          │
│                                                                              │
│  Error Response:                                                             │
│  {                                                                           │
│    "status": "error",                                                      │
│    "message": "Connection refused",                                        │
│    "data": []                                                              │
│  }                                                                          │
│                                                                              │
│  Status Codes:                                                               │
│  ├── 200 OK - Request successful                                           │
│  ├── 400 Bad Request - Invalid input                                       │
│  ├── 404 Not Found - Resource not found                                    │
│  ├── 500 Server Error - Database error                                     │
│  └── 503 Service Unavailable - Database unreachable                        │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                    ↓
                            HTTP RESPONSE
                                    ↓
                    JSON + CORS Headers + Status Code
                                    ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                    FRONTEND LAYER (Response Handling)                        │
│                                                                              │
│  HttpClient Subscription:                                                    │
│  this.ingestionApi.getIngestionPreview()                                   │
│    .pipe(takeUntilDestroyed())                                             │
│    .subscribe({                                                             │
│      next: (response) => {                                                 │
│        // 1. Extract data from response                                     │
│        const data = response.data || response.rows || [];                  │
│        // 2. Update reactive signal                                         │
│        this.rows.set(data);                                                │
│        // 3. Update UI (automatic with Angular Signals)                    │
│        // 4. Stop loading spinner                                           │
│        this.isLoading.set(false);                                          │
│      },                                                                     │
│      error: (err) => {                                                     │
│        // 1. Log error to console                                           │
│        // 2. Display error message                                          │
│        // 3. Stop loading spinner                                           │
│      }                                                                      │
│    });                                                                      │
│                                                                              │
│  Template Rendering:                                                         │
│  *ngFor="let row of rows()"                                                │
│    → Creates table row for each database record                            │
│                                                                              │
│  Data Binding:                                                               │
│  {{ row.blurb }}                                                            │
│    → Displays field value in table cell                                    │
│                                                                              │
│  User Interaction:                                                           │
│  (click)="startEdit(row, 'blurb')"                                         │
│    → Enables inline editing mode                                           │
│                                                                              │
│  Form Input:                                                                 │
│  [(ngModel)]="row.blurb"                                                   │
│    → Two-way binding with edited value                                    │
│                                                                              │
│  Save Trigger:                                                               │
│  (keyup.enter)="saveField(row, 'blurb')"                                   │
│    → Sends PUT request with updated value                                 │
│                                                                              │
│  UI State Management (Signals):                                             │
│  isLoading() → Show/hide spinner                                           │
│  error() → Show/hide error message                                         │
│  editingRowId() → Highlight editing row                                   │
│  editingField() → Show edit controls                                       │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 📊 Request/Response Cycle

### Cycle 1: Load Data (GET)

```
[FRONTEND]                           [BACKEND]                          [DATABASE]
    │                                    │                                   │
    │  1. User opens page                │                                   │
    │  2. ngOnInit() fires               │                                   │
    │  3. Signal isLoading = true        │                                   │
    │                                    │                                   │
    │  4. GET /api/ingestion-preview    │                                   │
    ├───────────────────────────────────→│                                   │
    │                                    │  5. Receive request              │
    │                                    │  6. Log: GET request              │
    │                                    │  7. Build SQL query               │
    │                                    │  8. JdbcTemplate.queryForList()   │
    │                                    ├──────────────────────────────────→│
    │                                    │                                   │ 9. SELECT
    │                                    │                                   │    TOP 5
    │                                    │                                   │ 10.FROM
    │                                    │                                   │    Ingestion
    │                                    │                                   │ 11.Return
    │                                    │                                   │    Result
    │                                    │←──────────────────────────────────┤
    │                                    │ 12. Result Set: List<Map>        │
    │                                    │ 13. Build response JSON          │
    │                                    │ 14. Set status: "success"        │
    │                                    │ 15. Add CORS headers             │
    │  16. 200 OK + JSON Response       │                                   │
    │←───────────────────────────────────┤                                   │
    │ { "data": [...], "status": "..." } │                                   │
    │                                    │                                   │
    │ 17. Update signal: rows.set(data) │                                   │
    │ 18. Update signal: isLoading=false│                                   │
    │ 19. *ngFor updates table          │                                   │
    │ 20. Table displays data            │                                   │
    │ 21. Spinner hides                 │                                   │
    ✓ GRID SHOWS DATA FROM DATABASE     │                                   │
```

### Cycle 2: Update Field (PUT)

```
[FRONTEND]                           [BACKEND]                          [DATABASE]
    │                                    │                                   │
    │  1. User clicks on cell            │                                   │
    │  2. Edit mode enabled              │                                   │
    │  3. User types new value           │                                   │
    │  4. User presses Enter             │                                   │
    │                                    │                                   │
    │  5. PUT /api/ingestion-preview/1  │                                   │
    │     { "blurb": "New Value" }      │                                   │
    ├───────────────────────────────────→│                                   │
    │                                    │  6. Receive request              │
    │                                    │  7. Log: PUT request              │
    │                                    │  8. Extract fieldName: "blurb"   │
    │                                    │  9. Extract value: "New Value"   │
    │                                    │ 10. Build UPDATE SQL             │
    │                                    │ 11. Validate fieldName           │
    │                                    │ 12. JdbcTemplate.update()        │
    │                                    ├──────────────────────────────────→│
    │                                    │                                   │ 13.UPDATE
    │                                    │                                   │    Ingestion
    │                                    │                                   │ 14.SET blurb
    │                                    │                                   │ 15.WHERE id
    │                                    │                                   │ 16.COMMIT
    │                                    │                                   │ 17.Rows
    │                                    │                                   │    Affected:1
    │                                    │←──────────────────────────────────┤
    │                                    │ 18. rowsAffected: 1             │
    │                                    │ 19. Build response              │
    │                                    │ 20. Set status: "success"       │
    │  21. 200 OK + Confirmation        │                                   │
    │←───────────────────────────────────┤                                   │
    │ { "status": "success", "id": 1 }  │                                   │
    │                                    │                                   │
    │ 22. Update signal: editingRowId=null                                  │
    │ 23. Exit edit mode                 │                                   │
    │ 24. Show success message           │                                   │
    │ 25. Cell displays new value        │                                   │
    ✓ FIELD UPDATED IN DATABASE & UI    │                                   │
```

### Cycle 3: Commit All (POST)

```
[FRONTEND]                           [BACKEND]                          [DATABASE]
    │                                    │                                   │
    │  1. User clicks "Commit All"       │                                   │
    │  2. Confirmation dialog            │                                   │
    │  3. User confirms                  │                                   │
    │  4. isLoading = true               │                                   │
    │                                    │                                   │
    │  5. POST /api/ingestion-preview   │                                   │
    │     { "all": true }               │                                   │
    ├───────────────────────────────────→│                                   │
    │                                    │  6. Receive commit request       │
    │                                    │  7. Log: POST COMMIT              │
    │                                    │  8. Extract commitAll: true      │
    │                                    │  9. TODO: Call sp_Commit...      │
    │                                    │ 10. Build response               │
    │                                    │ 11. Set commitId                 │
    │  12. 200 OK + Commit ID           │                                   │
    │←───────────────────────────────────┤                                   │
    │ { "status": "success", "commitId" │                                   │
    │                                    │                                   │
    │ 13. Show success alert             │                                   │
    │ 14. Reload grid data               │                                   │
    │ 15. Refresh from database          │                                   │
    │ 16. Show updated state             │                                   │
    ✓ COMMIT COMPLETE                   │                                   │
```

---

## 🔗 Component Integration Points

### Frontend Components
```
app.component.ts (Root)
  └── ingestion-preview-grid.component.ts
      ├── Signals: rows, isLoading, error, editingRowId, editingField
      ├── Methods: loadIngestionPreview(), startEdit(), saveField(), commitAll()
      ├── Template: ingestion-preview-grid.component.html
      └── Styles: ingestion-preview-grid.component.scss
           └── HttpClient via IngestionApiService
```

### Backend Components
```
ApologeticsCrucibleBackendApplication.java (Spring Boot Entry Point)
  └── IngestionPreviewController.java
      ├── @GetMapping: getPreview()
      ├── @PutMapping: updateField()
      ├── @PostMapping: commitPreview()
      ├── JdbcTemplate: jdbcTemplate (Injected)
      ├── Logger: SLF4J logging
      └── Error Handling: Comprehensive exception catching
           └── DataSource Configuration (application.properties)
```

### Database Connection
```
SQL Server 2019
  ├── Connection Pool (HikariCP via Spring Boot)
  ├── Driver: SQLServerDriver
  ├── Authentication: SA + Password
  └── Database: ApologeticsCrucible
       └── Table: IngestionPreview
```

---

## 🎯 Key Integration Points

### 1. CORS Headers
```
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type
withCredentials: true (in frontend HttpClient)
```

### 2. JSON Serialization
```
Frontend: Angular HttpClient automatically serializes/deserializes JSON
Backend: Spring Boot Jackson automatically converts Map to JSON
Database: JdbcTemplate converts ResultSet to Map<String, Object>
```

### 3. Error Handling
```
Frontend: Signals update error state, display error message
Backend: Try-catch logs exception, returns error response
Database: Connection errors propagate as exceptions
```

### 4. Logging Pipeline
```
Frontend: console.log() → Browser DevTools Console
Backend: SLF4J logger → Application logs (stdout/file)
Database: SQL query execution → SQL Server logs
```

---

## ✨ Architecture Highlights

✅ **Thin Frontend**: UI orchestration only, no business logic
✅ **Thin Backend**: REST API layer, delegates to database
✅ **Strong Typing**: TypeScript frontend, Java backend
✅ **Reactive State**: Angular Signals (no subscription hell)
✅ **CORS Enabled**: Cross-origin requests fully supported
✅ **Error Handling**: Comprehensive exception handling at all layers
✅ **Logging**: Detailed logging for debugging
✅ **Validation**: SQL injection prevention, field name validation
✅ **Flexibility**: Name/value pair updates support
✅ **Scalability**: Ready for stored procedures

---

## 📈 Performance Considerations

- **Frontend**: Signals provide reactive updates without manual subscriptions
- **Backend**: Connection pooling (HikariCP) manages database connections
- **Database**: Indexes on id, query limits (TOP 5) prevent large result sets
- **Network**: JSON format is lightweight and efficient
- **Caching**: Can be added at any layer for frequently accessed data

---

**Status**: 🟢 System ready for end-to-end testing

