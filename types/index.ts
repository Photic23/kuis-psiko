export type UUID = string & { readonly brand: unique symbol };

export type Test = {
  id: UUID;
  slug: string;
  name: string;
  description: string | null;
  is_active: boolean;
};

export type Subscale = {
  id: UUID;
  test_id: UUID;
  key: 'physical' | 'verbal' | 'cyber';
  name: string;
};

export type Item = {
  id: UUID;
  test_id: UUID;
  order_index: number;
  text: string;
  is_active: boolean;
};

export type ResultBandRow = {
  id: UUID;
  test_id: UUID;
  subscale_id: UUID | null;
  label: string;
  min_score: number;
  max_score: number;
  statement: string;
};


