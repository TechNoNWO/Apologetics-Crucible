import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { IngestionApiService } from '../../services/ingestion-api.service';
import { IngestionPreviewRow } from '../../models/ingestion.model';

/**
 * Ingestion Preview Grid Component
 * Displays ingestion preview data in an editable grid
 * Highest priority feature: displays data from /api/ingestion-preview
 */
@Component({
  selector: 'app-ingestion-preview-grid',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './ingestion-preview-grid.component.html',
  styleUrls: ['./ingestion-preview-grid.component.scss']
})
export class IngestionPreviewGridComponent implements OnInit {
  // Reactive state using Angular Signals
  rows = signal<IngestionPreviewRow[]>([]);
  isLoading = signal(false);
  error = signal<string | null>(null);
  editingRowId = signal<string | number | null>(null);
  editingField = signal<string | null>(null);
  originalValue = signal<any>(null);

  constructor(private ingestionApi: IngestionApiService) {}

  ngOnInit(): void {
    this.loadIngestionPreview();
  }

  /**
   * Load ingestion preview data from the backend
   */
  loadIngestionPreview(): void {
    this.isLoading.set(true);
    this.error.set(null);

    this.ingestionApi.getIngestionPreview().subscribe({
      next: (response) => {
        // Support flexible backend response structures
        const data = response.data || response.rows || [];
        this.rows.set(data);
        this.isLoading.set(false);
      },
      error: (err) => {
        console.error('Error loading ingestion preview:', err);
        this.error.set(err.message || 'Failed to load ingestion preview');
        this.isLoading.set(false);
      }
    });
  }

  /**
   * Start inline editing for a field
   */
  startEdit(row: IngestionPreviewRow, fieldName: string): void {
    this.editingRowId.set(row.id || null);
    this.editingField.set(fieldName);
    this.originalValue.set(row[fieldName]);
  }

  /**
   * Cancel the current edit
   */
  cancelEdit(): void {
    this.editingRowId.set(null);
    this.editingField.set(null);
    this.originalValue.set(null);
  }

  /**
   * Save the edited field value
   */
  saveField(row: IngestionPreviewRow, fieldName: string): void {
    const rowId = row.id;
    if (!rowId) return;

    this.ingestionApi.updateField(rowId, fieldName, row[fieldName]).subscribe({
      next: () => {
        this.cancelEdit();
      },
      error: (err) => {
        console.error('Error saving field:', err);
        this.error.set('Failed to save field');
        // Restore original value on error
        row[fieldName] = this.originalValue();
        this.cancelEdit();
      }
    });
  }

  /**
   * Commit all ingestion preview rows to nodes (one-click commit button)
   */
  commitAll(): void {
    if (!confirm('Are you sure you want to commit all rows to nodes?')) {
      return;
    }

    this.isLoading.set(true);
    this.error.set(null);

    this.ingestionApi.commitIngestionPreview({ all: true }).subscribe({
      next: (response) => {
        this.isLoading.set(false);
        alert(`Successfully committed ${this.rows().length} rows to nodes`);
        // Reload the data after commit
        this.loadIngestionPreview();
      },
      error: (err) => {
        console.error('Error committing ingestion preview:', err);
        this.error.set(err.message || 'Failed to commit ingestion preview');
        this.isLoading.set(false);
      }
    });
  }

  /**
   * Get strength badge color based on value
   */
  getStrengthBadgeClass(strength: string | undefined): string {
    if (!strength) return 'badge-secondary';
    const lower = strength.toLowerCase();
    if (lower.includes('strong')) return 'badge-success';
    if (lower.includes('moderate')) return 'badge-warning';
    if (lower.includes('weak')) return 'badge-danger';
    return 'badge-secondary';
  }

  /**
   * Check if a field is currently being edited
   */
  isEditing(rowId: string | number | undefined, fieldName: string): boolean {
    return this.editingRowId() === rowId && this.editingField() === fieldName;
  }
}

