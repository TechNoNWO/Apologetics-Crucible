# Technical Reference - End-to-End Testing
## Complete Setup for UI ↔ API ↔ Database

---

## 🔧 Backend API Reference

### GET /api/ingestion-preview
**Purpose**: Retrieve ingestion preview data from database

**Request**:
```http
GET http://localhost:8080/api/ingestion-preview
Content-Type: application/json
```

**Response (Success)**:
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "sourceText": "Genesis 1:1",
      "blurb": "Creation narrative",
      "suggestedStrength": "Strong",
      "associationType": "Direct",
      "propositionId": 101
    },
    {
      "id": 2,
      "sourceText": "John 3:16",
      "blurb": "God's love for humanity",
      "suggestedStrength": "Strong",
      "associationType": "Direct",
      "propositionId": 102
    }
  ],
  "count": 2,
  "message": "Retrieved 2 records from database"
}
```

**Response (Error)**:
```json
{
  "status": "error",
  "message": "Connection refused to SQL Server",
  "data": []
}
```

**Frontend Integration**:
```typescript
this.ingestionApi.getIngestionPreview()
  .subscribe({
    next: (response) => {
      this.rows.set(response.data || []);
    },
    error: (err) => {
      this.error.set(err.message);
    }
  });
```

---

### PUT /api/ingestion-preview/{id}
**Purpose**: Update a single field in database

**Request**:
```http
PUT http://localhost:8080/api/ingestion-preview/1
Content-Type: application/json

{
  "blurb": "Updated description",
  "suggestedStrength": "Moderate"
}
```

**Response (Success)**:
```json
{
  "status": "success",
  "message": "Updated in database",
  "id": 1,
  "updates": {
    "blurb": "Updated description",
    "suggestedStrength": "Moderate"
  }
}
```

**Frontend Integration**:
```typescript
this.ingestionApi.updateField(row.id, 'blurb', 'New value')
  .subscribe({
    next: () => {
      this.cancelEdit();
    },
    error: (err) => {
      this.error.set('Failed to save: ' + err.message);
    }
  });
```

---

### POST /api/ingestion-preview
**Purpose**: Commit ingestion preview records to nodes

**Request**:
```http
POST http://localhost:8080/api/ingestion-preview
Content-Type: application/json

{
  "all": true
}
```

**Response (Success)**:
```json
{
  "status": "success",
  "message": "Committed to database successfully",
  "commitId": 1712864400000,
  "commitAll": true
}
```

**Frontend Integration**:
```typescript
this.ingestionApi.commitIngestionPreview({ all: true })
  .subscribe({
    next: (response) => {
      alert('Committed ' + response.recordsCommitted + ' records');
      this.loadIngestionPreview();
    },
    error: (err) => {
      this.error.set('Commit failed: ' + err.message);
    }
  });
```

---

## 📊 Frontend Service Reference

### IngestionApiService

**Constructor Injection**:
```typescript
constructor(private http: HttpClient) {}
```

**Methods**:

```typescript
// Get all ingestion preview records
getIngestionPreview(): Observable<IngestionPreviewResponse>

// Update single field
updateField(
  rowId: string | number, 
  fieldName: string, 
  fieldValue: any
): Observable<any>

// Update multiple fields
updateRow(
  rowId: string | number, 
  updates: UpdatePayload
): Observable<any>

// Commit records
commitIngestionPreview(request: CommitRequest): Observable<CommitResponse>
```

**Configuration**:
```typescript
private readonly apiUrl = `${environment.apiBaseUrl}/api/ingestion-preview`;

// All requests include credentials for CORS
this.http.get<T>(url, { withCredentials: true })
```

---

## 🗄️ Database Schema

### IngestionPreview Table

```sql
CREATE TABLE IngestionPreview (
    id INT PRIMARY KEY IDENTITY(1,1),
    sourceText NVARCHAR(MAX),
    blurb NVARCHAR(MAX),
    suggestedStrength NVARCHAR(50),
    associationType NVARCHAR(100),
    propositionId INT,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE()
);
```

### Sample Data

```sql
INSERT INTO IngestionPreview (sourceText, blurb, suggestedStrength, associationType, propositionId)
VALUES
('Genesis 1:1', 'Creation narrative', 'Strong', 'Direct', 1),
('John 3:16', 'God''s love', 'Strong', 'Direct', 2),
('Psalm 23:1', 'Trust and care', 'Moderate', 'Metaphor', 3);
```

---

## 🌐 HTTP Headers

### Frontend Sends
```
Content-Type: application/json
Origin: http://localhost:4200
```

### Backend Responds
```
Content-Type: application/json;charset=UTF-8
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type
Vary: Origin,Access-Control-Request-Method,Access-Control-Request-Headers
```

---

## 🐛 Debugging Checklist

### Frontend Debugging

**Check 1: API Service**
```typescript
// In browser console:
// Verify service is calling correct URL
console.log(environment.apiBaseUrl); // Should be http://localhost:8080
```

**Check 2: HTTP Request**
```
DevTools → Network tab
- Watch for GET /api/ingestion-preview request
- Check Status Code: should be 200
- Check Response: should contain JSON data
```

**Check 3: Signal Update**
```typescript
// In component:
console.log('Rows:', this.rows()); // Should show array of records
console.log('Loading:', this.isLoading()); // Should be false
console.log('Error:', this.error()); // Should be null
```

**Check 4: Template Rendering**
```html
<!-- In browser DevTools Elements tab:
     - Find: <table> element
     - Check: <tr> elements for each row
     - Verify: data binding shows actual values
-->
```

---

### Backend Debugging

**Check 1: Spring Boot Started**
```
Terminal output should show:
- "Started ApologeticsCrucibleBackendApplication"
- "Tomcat started on port 8080"
```

**Check 2: Database Connected**
```
Logs should show:
- "HikariPool-1" (connection pool)
- "Connection is valid"
- No "Connection refused" errors
```

**Check 3: API Call Received**
```
Logs should show:
═══════════════════════════════════════════
GET /api/ingestion-preview
Query: SQL Server Database
═══════════════════════════════════════════
```

**Check 4: Query Executed**
```
Logs should show:
✓ Retrieved N records from database
✓ Response sent to Frontend
```

---

### Database Debugging

**Check 1: SQL Server Running**
```powershell
# Verify service is running
Get-Service MSSQLSERVER
```

**Check 2: Table Exists**
```sql
-- In SQL Server Management Studio:
SELECT * FROM ApologeticsCrucible.dbo.IngestionPreview;
```

**Check 3: Data Exists**
```sql
-- Count records:
SELECT COUNT(*) FROM IngestionPreview;
```

**Check 4: Connectivity**
```
Connection String: 
jdbc:sqlserver://localhost:1433;databaseName=ApologeticsCrucible
Username: sa
Password: YourPassword@123
```

---

## 🔍 Common Issues & Solutions

### Issue: API returns 404
**Cause**: Backend not running
**Solution**: 
```powershell
# Check if port 8080 is listening
Get-NetTCPConnection -LocalPort 8080

# If not, start backend:
.\mvnw.cmd spring-boot:run
```

### Issue: API returns 500 with database error
**Cause**: Database connection failed
**Solution**:
1. Verify SQL Server is running
2. Check credentials in application.properties
3. Ensure database and table exist
4. Check firewall allows port 1433

### Issue: Frontend shows "Cannot reach API"
**Cause**: CORS error or wrong API URL
**Solution**:
1. Check environment.ts has correct apiBaseUrl
2. Verify backend CORS is enabled (@CrossOrigin on controller)
3. Check Network tab for actual error

### Issue: Data not displaying in grid
**Cause**: Empty result set from database
**Solution**:
1. Check if table has data
2. Verify SELECT query in controller is correct
3. Check for SQL errors in backend logs

### Issue: Editing doesn't save
**Cause**: PUT endpoint not working
**Solution**:
1. Check Network tab for PUT request status
2. Verify backend received the request
3. Check database was actually updated
4. Look for validation errors in backend logs

---

## 📱 Testing with Different Scenarios

### Scenario 1: Happy Path (Everything Works)
```
1. Backend running on 8080 ✓
2. Frontend running on 4200 ✓
3. Database has data ✓
4. Grid displays data ✓
5. Edit works ✓
6. Save works ✓
7. Commit works ✓
```

### Scenario 2: No Database Data
```
1. Backend running ✓
2. Frontend running ✓
3. Database table empty or doesn't exist
4. Backend returns: { "status": "error", "data": [] }
5. Frontend shows: "No ingestion preview data available"
6. User clicks "Retry" button
```

### Scenario 3: Database Connection Error
```
1. Backend running ✓
2. Frontend running ✓
3. Database not accessible
4. Backend logs: "Connection refused"
5. Backend returns: { "status": "error", "message": "..." }
6. Frontend shows: error alert with message
```

---

## 📊 Performance Monitoring

### Backend Metrics
```
Monitor these in logs:
- Query execution time
- Rows returned count
- Connection pool status
- Error rate
```

### Frontend Metrics
```
Monitor these in DevTools:
- Network request duration
- JSON payload size
- Component render time
- Memory usage
```

### Database Metrics
```
Monitor in SQL Server:
- Query execution time
- Lock situations
- Connection count
- Disk I/O
```

---

## 🎯 Test Execution Order

1. **Startup Tests**
   - Backend starts successfully
   - Frontend starts successfully
   - Both services listen on correct ports

2. **Connectivity Tests**
   - Backend responds to health check
   - Frontend can reach backend
   - Database connection works

3. **Data Retrieval Tests**
   - GET returns data from database
   - Data format is correct JSON
   - All fields are populated

4. **Display Tests**
   - Frontend grid renders
   - Data displays correctly
   - Table has expected rows

5. **Interaction Tests**
   - Click cell to edit works
   - Value changes in input
   - Cancel discards changes

6. **Update Tests**
   - Save sends PUT request
   - Database updates
   - Frontend shows updated value

7. **Commit Tests**
   - Click commit button
   - POST request sent
   - Confirmation received

---

## ✅ Sign-Off Checklist

- [ ] Backend builds without errors
- [ ] Backend starts on port 8080
- [ ] Frontend builds without errors
- [ ] Frontend starts on port 4200
- [ ] Backend API responds to GET request
- [ ] Frontend receives JSON response
- [ ] Grid displays data from database
- [ ] User can edit a field
- [ ] Edited value is sent to backend
- [ ] Backend updates database
- [ ] Frontend shows updated value
- [ ] User can commit changes
- [ ] Backend receives commit request
- [ ] All CORS headers present
- [ ] No console errors in browser
- [ ] No exceptions in backend logs
- [ ] Database records verified

---

**Status**: Ready for end-to-end integration testing!

