# Apologetics Crucible Frontend - Changelog

## [0.0.1] - 2026-04-11

### Added
- **Project Setup**: Angular 18+ with standalone components, routing, and SCSS
- **Environment Configuration**: 
  - Development environment pointing to `http://localhost:8080`
  - Production environment for deployment
- **Data Models** (`src/app/models/ingestion.model.ts`):
  - `IngestionPreviewRow` - Flexible row interface
  - `IngestionPreviewResponse` - Backend response wrapper
  - `UpdatePayload` - For name/value pair updates
  - `CommitRequest` & `CommitResponse` - For commit operations
- **API Service** (`src/app/services/ingestion-api.service.ts`):
  - `getIngestionPreview()` - Fetch data from backend
  - `updateField()` - Update single field (name/value pair)
  - `updateRow()` - Update multiple fields
  - `commitIngestionPreview()` - Commit rows to nodes
  - All calls include `withCredentials: true` for CORS
- **Ingestion Preview Grid Component** (highest priority):
  - Standalone component with Angular Signals reactive state
  - Load and display ingestion preview data
  - Inline editing for: Blurb, SuggestedStrength, AssociationType
  - One-click "Commit All to Nodes" button
  - Strength badges with color coding (Strong, Moderate, Weak)
  - Error handling and loading states
  - Responsive Bootstrap-style table with SCSS styling
  - Support for flexible backend response structures
- **Root Component** (`app.component.ts`):
  - Gradient header with branding
  - HttpClientModule imported
  - Main layout container
  - Ingestion Preview Grid integrated

### Architecture Decisions
- **Angular Signals**: Used for reactive state management (modern Angular 18+ approach)
- **Standalone Components**: No NgModules required, self-contained components
- **Flexible Data Binding**: Models support `[key: string]: any` for backend flexibility
- **CORS-Ready**: All HTTP requests include `withCredentials: true`
- **Responsive Design**: Works seamlessly on desktop, tablet, and mobile
- **No Business Logic**: Frontend is pure UI orchestration, all logic stays on backend

### File Structure
```
src/
├── app/
│   ├── components/
│   │   └── ingestion-preview-grid/
│   │       ├── ingestion-preview-grid.component.ts
│   │       ├── ingestion-preview-grid.component.html
│   │       └── ingestion-preview-grid.component.scss
│   ├── models/
│   │   └── ingestion.model.ts
│   ├── services/
│   │   └── ingestion-api.service.ts
│   └── app.component.ts
├── environments/
│   ├── environment.ts
│   └── environment.prod.ts
└── ...
```

### Key Features
✅ Ingestion Preview Grid with editable fields
✅ Real-time inline editing with save/cancel
✅ Commit all rows to nodes (one-click button)
✅ Strength badges with visual indicators
✅ Error handling and user feedback
✅ Loading states and empty states
✅ Responsive, mobile-friendly design
✅ Proper TypeScript typing (no `any` in component logic)

### Future Features (in priority order)
- Interactive proof graph (Cytoscape.js or vis-network)
- RHS panel for exegetic details, categories, cross-references
- Proof comparison view
- Sacred text browser
- Advanced filtering and search
- Bulk operations
- Export/import functionality

### Testing & Quality Standards
- ESLint + Prettier configured (run: `npm run lint`)
- Husky pre-commit hooks (run: `npm run prepare`)
- Jasmine/Karma unit tests (run: `npm test`)
- Playwright E2E tests (run: `npm run e2e`)

### Running the Frontend
```bash
cd ApologeticsCrucible-FrontEnd
npm install
npm start
# Navigate to http://localhost:4200
```

### API Integration
- Backend URL: `http://localhost:8080` (development)
- Endpoint: `/api/ingestion-preview`
- CORS: Fully enabled on backend
- Authentication: Ready for credentials-based auth

### Notes
- All components are standalone (no NgModules)
- State management uses Angular Signals
- HTTP client is provided at root level
- Bootstrap classes used for styling (can be replaced with custom theme)
- SCSS variables defined for theme consistency

