import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { IngestionPreviewResponse, UpdatePayload, CommitRequest, CommitResponse } from '../models/ingestion.model';

/**
 * API service for Ingestion Preview operations
 * Handles all REST API calls to the backend
 */
@Injectable({
  providedIn: 'root'
})
export class IngestionApiService {
  private readonly apiUrl = `${environment.apiBaseUrl}/api/ingestion-preview`;

  constructor(private http: HttpClient) {}

  /**
   * Fetch ingestion preview data from the backend
   */
  getIngestionPreview(): Observable<IngestionPreviewResponse> {
    return this.http.get<IngestionPreviewResponse>(this.apiUrl, {
      withCredentials: true
    });
  }

  /**
   * Update a single field in an ingestion preview row (name/value pair update)
   * @param rowId - The ID of the row to update
   * @param fieldName - The name of the field
   * @param fieldValue - The new value
   */
  updateField(rowId: string | number, fieldName: string, fieldValue: any): Observable<any> {
    const payload: UpdatePayload = { [fieldName]: fieldValue };
    return this.http.put(`${this.apiUrl}/${rowId}`, payload, {
      withCredentials: true
    });
  }

  /**
   * Update multiple fields in a row (flexible name/value pair update)
   * @param rowId - The ID of the row to update
   * @param updates - Object containing field names and their new values
   */
  updateRow(rowId: string | number, updates: UpdatePayload): Observable<any> {
    return this.http.put(`${this.apiUrl}/${rowId}`, updates, {
      withCredentials: true
    });
  }

  /**
   * Commit ingestion preview rows to nodes
   * @param request - Commit request (can specify rowIds or commit all)
   */
  commitIngestionPreview(request: CommitRequest): Observable<CommitResponse> {
    return this.http.post<CommitResponse>(this.apiUrl, request, {
      withCredentials: true
    });
  }
}

