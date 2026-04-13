# Apologetics Crucible Frontend - Architecture & Setup Guide

## Project Overview

**Apologetics Crucible Frontend** is a thin, reactive UI layer built with Angular 18+ standalone components. The frontend communicates exclusively with the Spring Boot backend via REST APIs and does NOT contain any business logic.

### Technology Stack
- **Framework**: Angular 18+
- **Language**: TypeScript 5.x
- **Styling**: SCSS
- **Component Architecture**: Standalone components only (no NgModules)
- **State Management**: Angular Signals (reactive, no RxJS subscription hell)
- **HTTP**: HttpClient with withCredentials for CORS
- **Styling Framework**: Bootstrap 5 (for base, SCSS for customization)

---

## Architecture Principles

### 1. **Thin UI Layer Only**
- ❌ NO business logic, calculations, or data processing
- ✅ Display data from backend
- ✅ Send user input to backend
- ✅ Manage UI state (loading, errors, editing, etc.)

### 2. **Standalone Components**
All components must be standalone:
```typescript
@Component({
  selector: 'app-example',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `...`
})
export class ExampleComponent {}
```

### 3. **Angular Signals for State**
Use Signals instead of RxJS where possible:
```typescript
count = signal(0);
isLoading = signal(false);
items = signal<Item[]>([]);

// Update
count.set(count() + 1);

// Read
console.log(count()); // Get current value
```

### 4. **Name/Value Pair Updates**
Frontend sends flexible JSON payloads:
```typescript
// Update a single field
{ fieldName: newValue }

// Update multiple fields
{ field1: value1, field2: value2 }
```

### 5. **CORS Configuration**
All HTTP requests must include credentials:
```typescript
this.http.get<T>(url, {
  withCredentials: true
})
```

---

## Project Structure

```
ApologeticsCrucible-FrontEnd/
├── src/
│   ├── app/
│   │   ├── components/
│   │   │   ├── ingestion-preview-grid/
│   │   │   │   ├── ingestion-preview-grid.component.ts
│   │   │   │   ├── ingestion-preview-grid.component.html
│   │   │   │   └── ingestion-preview-grid.component.scss
│   │   │   ├── proof-graph/ (future)
│   │   │   ├── exegetic-panel/ (future)
│   │   │   └── ...
│   │   ├── models/
│   │   │   ├── ingestion.model.ts
│   │   │   ├── proof.model.ts (future)
│   │   │   └── ...
│   │   ├── services/
│   │   │   ├── ingestion-api.service.ts
│   │   │   ├── proof-api.service.ts (future)
│   │   │   └── ...
│   │   ├── guards/ (future)
│   │   ├── interceptors/ (future)
│   │   ├── app.component.ts
│   │   ├── app.config.ts (future)
│   │   └── app.routes.ts (future)
│   ├── environments/
│   │   ├── environment.ts (dev)
│   │   └── environment.prod.ts (prod)
│   ├── main.ts
│   └── styles.scss
├── package.json
├── tsconfig.json
├── angular.json
└── FRONTEND_CHANGELOG.md
```

---

## Component Development Guide

### Creating a New Standalone Component

1. **Create the component file**:
```typescript
import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-my-component',
  standalone: true,
  imports: [CommonModule, FormsModule],  // Import what you need
  template: `<div>{{ message() }}</div>`,
  styles: []
})
export class MyComponent implements OnInit {
  message = signal('Hello');

  constructor() {}

  ngOnInit(): void {
    // Initialize component
  }
}
```

2. **Use signals for state**:
```typescript
export class MyComponent {
  // Simple state
  isLoading = signal(false);
  
  // Complex state
  items = signal<Item[]>([]);
  
  // Computed derived state (future Angular 18.1+)
  itemCount = computed(() => this.items().length);
}
```

3. **Subscribe to services** (use takeUntilDestroyed):
```typescript
constructor(private myService: MyService) {
  this.myService.getData()
    .pipe(takeUntilDestroyed())  // Auto-unsubscribe on destroy
    .subscribe(data => this.items.set(data));
}
```

---

## Service Development Guide

### Creating an API Service

1. **Define interfaces** in `models/`:
```typescript
export interface MyData {
  id: string;
  name: string;
  [key: string]: any;  // Support flexible responses
}

export interface MyResponse {
  data?: MyData[];
  [key: string]: any;
}
```

2. **Create service in `services/`**:
```typescript
@Injectable({ providedIn: 'root' })
export class MyApiService {
  private apiUrl = `${environment.apiBaseUrl}/api/my-endpoint`;

  constructor(private http: HttpClient) {}

  getData(): Observable<MyResponse> {
    return this.http.get<MyResponse>(this.apiUrl, {
      withCredentials: true
    });
  }

  updateItem(id: string, updates: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/${id}`, updates, {
      withCredentials: true
    });
  }
}
```

---

## State Management with Signals

### Simple State
```typescript
export class MyComponent {
  count = signal(0);

  increment(): void {
    this.count.set(this.count() + 1);
  }

  // In template:
  // {{ count() }}
}
```

### Complex State with Methods
```typescript
export class MyComponent {
  items = signal<Item[]>([]);
  isLoading = signal(false);
  error = signal<string | null>(null);

  constructor(private service: MyService) {}

  loadItems(): void {
    this.isLoading.set(true);
    this.error.set(null);

    this.service.getItems()
      .pipe(takeUntilDestroyed())
      .subscribe({
        next: (items) => {
          this.items.set(items);
          this.isLoading.set(false);
        },
        error: (err) => {
          this.error.set(err.message);
          this.isLoading.set(false);
        }
      });
  }
}
```

---

## HTTP Client Setup

HttpClientModule is already provided in the root component. All services can inject and use it:

```typescript
constructor(private http: HttpClient) {}

// All requests automatically include credentials
this.http.get<T>(url, { withCredentials: true });
this.http.post<T>(url, data, { withCredentials: true });
this.http.put<T>(url, data, { withCredentials: true });
this.http.delete(url, { withCredentials: true });
```

---

## Template Binding with Signals

### Basic Binding
```html
<!-- Read signal -->
<p>{{ count() }}</p>

<!-- Use in *ngIf -->
<div *ngIf="isLoading()">Loading...</div>

<!-- Use in *ngFor -->
<div *ngFor="let item of items()">{{ item.name }}</div>
```

### Two-Way Binding
```html
<input [(ngModel)]="myField">
```

### Event Binding
```html
<button (click)="onClick()">Click me</button>
<input (keyup.enter)="onEnter()">
```

---

## Styling Guide

### SCSS Best Practices

1. **Use variables for consistency**:
```scss
$primary-color: #007bff;
$font-size-base: 1rem;
$border-radius: 4px;

.component {
  color: $primary-color;
  border-radius: $border-radius;
}
```

2. **Nested selectors for readability**:
```scss
.container {
  .header {
    padding: 1rem;
  }

  .body {
    padding: 2rem;
  }
}
```

3. **Responsive design**:
```scss
.grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1rem;

  @media (max-width: 1200px) {
    grid-template-columns: repeat(3, 1fr);
  }

  @media (max-width: 768px) {
    grid-template-columns: repeat(1, 1fr);
  }
}
```

---

## Testing Strategy

### Unit Tests (Jasmine/Karma)
- Test component logic in isolation
- Mock services with spies
- Test signal updates and user interactions
- Run: `npm test`

### E2E Tests (Playwright)
- Test complete user workflows
- Test integration between frontend and backend
- Test ingestion preview grid (inline editing, commit flow)
- Run: `npm run e2e`

### Code Quality
- Run `npm run lint` to check code style
- Run `npm run format` to auto-format code
- Husky prevents commits with linting errors

---

## Common Patterns

### Loading Data from Backend
```typescript
export class MyComponent implements OnInit {
  data = signal<any[]>([]);
  isLoading = signal(false);
  error = signal<string | null>(null);

  constructor(private service: MyService) {}

  ngOnInit(): void {
    this.loadData();
  }

  loadData(): void {
    this.isLoading.set(true);
    this.error.set(null);

    this.service.getData()
      .pipe(takeUntilDestroyed())
      .subscribe({
        next: (response) => {
          this.data.set(response.data || []);
          this.isLoading.set(false);
        },
        error: (err) => {
          this.error.set(err.message || 'Error loading data');
          this.isLoading.set(false);
        }
      });
  }
}
```

### Inline Editing Pattern
```typescript
export class MyComponent {
  items = signal<Item[]>([]);
  editingId = signal<string | null>(null);
  editingField = signal<string | null>(null);

  startEdit(id: string, field: string): void {
    this.editingId.set(id);
    this.editingField.set(field);
  }

  cancelEdit(): void {
    this.editingId.set(null);
    this.editingField.set(null);
  }

  saveField(item: Item, field: string): void {
    this.service.updateField(item.id, field, item[field])
      .pipe(takeUntilDestroyed())
      .subscribe({
        next: () => this.cancelEdit(),
        error: (err) => alert('Save failed: ' + err.message)
      });
  }

  isEditing(id: string, field: string): boolean {
    return this.editingId() === id && this.editingField() === field;
  }
}
```

---

## Running the Frontend

### Development
```bash
cd ApologeticsCrucible-FrontEnd
npm install
npm start
# Open http://localhost:4200
```

### Production Build
```bash
npm run build
# Output in dist/
```

### Code Quality
```bash
npm run lint         # Check code style
npm run format       # Format code
npm run test         # Run unit tests
npm run e2e          # Run E2E tests
```

---

## Integration with Backend

The frontend expects the backend to run on `http://localhost:8080` (configurable via environments).

### Endpoints Required
- `GET /api/ingestion-preview` - Get ingestion preview data
- `PUT /api/ingestion-preview/{id}` - Update a row
- `POST /api/ingestion-preview` - Commit preview to nodes

### Expected Response Format
```json
{
  "data": [
    {
      "id": "1",
      "sourceText": "...",
      "blurb": "...",
      "suggestedStrength": "Strong",
      "associationType": "...",
      "propositionId": "1"
    }
  ]
}
```

---

## Next Steps

1. Verify frontend builds: `npm run build`
2. Run development server: `npm start`
3. Connect to running backend on port 8080
4. Test ingestion preview grid UI
5. Implement additional components as needed

For questions or issues, refer to the Angular documentation or the project architecture specification.

