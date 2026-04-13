import { Component } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';
import { IngestionPreviewGridComponent } from './components/ingestion-preview-grid/ingestion-preview-grid.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [HttpClientModule, IngestionPreviewGridComponent],
  template: `
    <div class="app-container">
      <header class="app-header">
        <h1>Apologetics Crucible</h1>
        <p class="subtitle">Interactive Logical & Exegetical Proof Builder</p>
      </header>

      <main class="app-main">
        <app-ingestion-preview-grid></app-ingestion-preview-grid>
      </main>
    </div>
  `,
  styles: [`
    .app-container { min-height: 100vh; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
    .app-header { background-color: rgba(0,0,0,0.7); color: white; padding: 2rem; text-align: center; border-bottom: 3px solid #667eea; }
    .app-header h1 { margin: 0; font-size: 2.5rem; font-weight: 700; }
    .app-header .subtitle { margin: 0.5rem 0 0 0; font-size: 1rem; color: #ccc; }
    .app-main { max-width: 1400px; margin: 2rem auto; padding: 0 1rem; }
  `]
})
export class AppComponent {}
