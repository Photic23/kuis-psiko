export type ResultBand = {
  label: string;
  min_score: number;
  max_score: number;
  statement: string;
};

export function mapScoreToBand(score: number, bands: ResultBand[]): ResultBand | null {
  for (const band of bands) {
    if (score >= band.min_score && score <= band.max_score) return band;
  }
  return null;
}


