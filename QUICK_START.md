# Quick Start Guide - Apologetics Crucible

## ⚡ 5-Minute Setup

### Prerequisites
- ✅ Java 21 (Eclipse Adoptium Temurin 21.0.10)
- ✅ Node.js 20+ (for npm)
- ✅ Angular CLI 18+
- ✅ Windows PowerShell or Git Bash

---

## 🚀 Start the Backend

```powershell
# Open PowerShell in: C:\Projects\Apologetics-Crucible\ApologeticsCrucible-BackEnd\ApologeticsCrucible-BackEnd

$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-21.0.10.7-hotspot"
.\mvnw.cmd spring-boot:run

# ✅ Backend running on http://localhost:8080
# Check: http://localhost:8080/api/ingestion-preview
```

### Expected Backend Response
```
Status: 200 OK
Body: Ingestion preview data
```

---

## 🎨 Start the Frontend

```bash
# Open Git Bash or PowerShell in: C:\Projects\Apologetics-Crucible\ApologeticsCrucible-FrontEnd

npm install  # Install dependencies (first time only)
npm start    # Start development server

# ✅ Frontend running on http://localhost:4200
```

### Expected Frontend Interface
- Header: "Apologetics Crucible"
- Subtitle: "Interactive Logical & Exegetical Proof Builder"
- Ingestion Preview Grid with table showing data from backend

---

## 🔗 Verify Integration

1. **Open Browser**: Navigate to `http://localhost:4200`
2. **Check Console**: Open DevTools (F12) → Console
3. **Verify Request**: Should see GET to `http://localhost:8080/api/ingestion-preview`
4. **Verify Response**: Table should display with data

---

## 🎯 Test Ingestion Preview Grid

### Load Data
- Grid automatically loads on component init
- Click "Retry" button if loading fails
- Check browser console for errors

### Edit a Field
1. Click on any cell in Blurb, SuggestedStrength, or AssociationType columns
2. Edit the value
3. Click ✓ to save or ✗ to cancel
4. Check network tab for PUT request to backend

### Commit to Nodes
1. Click "Commit All to Nodes" button
2. Confirm in dialog
3. Wait for success message
4. Grid automatically reloads

---

## 📊 Browser DevTools

### Network Tab
- Watch real-time API calls
- GET: `/api/ingestion-preview` - Initial data load
- PUT: `/api/ingestion-preview/{id}` - Field updates
- POST: `/api/ingestion-preview` - Commit operation

### Console Tab
- No errors should appear during normal operation
- API responses logged automatically
- Click "Retry" to trigger manual reload

---

## 🔧 Common Tasks

### Rebuild Backend
```powershell
cd C:\Projects\Apologetics-Crucible\ApologeticsCrucible-BackEnd\ApologeticsCrucible-BackEnd
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-21.0.10.7-hotspot"
.\mvnw.cmd clean install
```

### Rebuild Frontend
```bash
cd C:\Projects\Apologetics-Crucible\ApologeticsCrucible-FrontEnd
npm run build
# Output in dist/
```

### Stop Services
- **Backend**: Press `Ctrl+C` in PowerShell
- **Frontend**: Press `Ctrl+C` in terminal

### Clear Cache
```bash
# Frontend
rm -rf node_modules dist
npm install

# Backend
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-21.0.10.7-hotspot"
.\mvnw.cmd clean
```

---

## 📖 Documentation

### Backend
- **Setup**: See `ApologeticsCrucible-BackEnd/changelog.md`
- **API**: See Swagger at `http://localhost:8080/swagger-ui/index.html`
- **Code**: See `src/main/java/...` files

### Frontend
- **Setup**: See `FRONTEND_CHANGELOG.md`
- **Architecture**: See `ARCHITECTURE.md` (comprehensive guide)
- **Code**: See `src/app/...` files with comments

### Project
- **Overall Status**: See `PROJECT_STATUS.md`
- **This Guide**: You're reading it! 📄

---

## ❌ Troubleshooting

### Backend Won't Start

**Error**: "JAVA_HOME is set to an invalid directory"
```powershell
# Verify correct path:
Get-ChildItem "C:\Program Files\Eclipse Adoptium"

# Should show: jdk-21.0.10.7-hotspot (or similar)

# Then set:
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-21.0.10.7-hotspot"
```

**Error**: Port 8080 already in use
```powershell
# Find process on port 8080
Get-NetTCPConnection -LocalPort 8080

# Kill the process or use different port
```

### Frontend Won't Load

**Error**: "Cannot GET /"
```bash
# Make sure you're in the right directory:
cd C:\Projects\Apologetics-Crucible\ApologeticsCrucible-FrontEnd
npm start
```

**Error**: "Module not found"
```bash
# Reinstall dependencies:
rm -rf node_modules
npm install
npm start
```

### Backend API Returns Error

**Error**: Cannot reach http://localhost:8080/api/ingestion-preview
```powershell
# Verify backend is running
curl http://localhost:8080/api/ingestion-preview

# Or check in browser:
# http://localhost:8080/swagger-ui/index.html
```

### CORS Error in Browser

**Error**: "Access to XMLHttpRequest has been blocked by CORS policy"
- Backend CORS is already enabled
- Check browser console for exact error
- Verify backend is running
- Check that frontend is calling correct endpoint

---

## 📱 What's Working

✅ Backend REST API on port 8080
✅ Frontend Angular app on port 4200
✅ Ingestion Preview Grid component
✅ Inline editing (Blurb, SuggestedStrength, AssociationType)
✅ Commit all to nodes button
✅ Error handling and loading states
✅ Responsive design (desktop & mobile)
✅ CORS integration

---

## 🚀 Next Steps

1. ✅ Backend running? → Test API endpoints
2. ✅ Frontend running? → See Ingestion Preview Grid
3. ✅ Data loading? → Try editing and saving
4. ✅ Everything working? → Read `ARCHITECTURE.md` for development guide

---

## 💡 Tips

- **Hot Reload**: Frontend auto-reloads on file changes
- **Backend**: Requires restart for code changes
- **Debug**: Open DevTools (F12) to see API calls
- **Rebuild**: Use `npm run build` for production
- **Test**: Use `npm test` for unit tests

---

## 📞 Quick Reference

| Component | URL | Port |
|-----------|-----|------|
| Backend API | http://localhost:8080 | 8080 |
| Backend Swagger | http://localhost:8080/swagger-ui/index.html | 8080 |
| Backend OpenAPI | http://localhost:8080/v3/api-docs | 8080 |
| Frontend App | http://localhost:4200 | 4200 |
| Ingestion Preview | http://localhost:4200 (homepage) | 4200 |

---

**You're all set! Happy coding! 🎉**

