import { error } from '@sveltejs/kit';
import { getLegalDocumentBySlug } from '$lib/a11y';
import type { PageLoad } from './$types';

export const load: PageLoad = ({ params }) => {
  const doc = getLegalDocumentBySlug(params.slug);
  if (!doc) {
    throw error(404, `Không tìm thấy tài liệu pháp lý cho đường dẫn /legal/${params.slug}`);
  }
  return {
    document: doc
  };
};
