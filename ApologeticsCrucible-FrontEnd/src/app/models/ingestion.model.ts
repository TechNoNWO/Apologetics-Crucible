/**
 * IngestionPreviewRow interface represents a single row in the ingestion preview grid
 * All fields are optional to support flexible name/value pair updates from the backend
 */
export interface IngestionPreviewRow {
  id?: string | number;
  sourceText?: string;
  blurb?: string;
  suggestedStrength?: string;
  associationType?: string;
  propositionId?: string | number;
  [key: string]: any; // Support flexible backend responses
}

/**
 * IngestionPreviewResponse from the backend
 */
export interface IngestionPreviewResponse {
  data?: IngestionPreviewRow[];
  rows?: IngestionPreviewRow[];
  [key: string]: any;
}

/**
 * UpdatePayload for sending name/value pair updates to backend
 */
export interface UpdatePayload {
  [fieldName: string]: any;
}

/**
 * CommitRequest for committing ingestion preview to nodes
 */
export interface CommitRequest {
  rowIds?: (string | number)[];
  all?: boolean;
  [key: string]: any;
}

/**
 * CommitResponse from backend
 */
export interface CommitResponse {
  success?: boolean;
  message?: string;
  commitId?: string | number;
  [key: string]: any;
}

