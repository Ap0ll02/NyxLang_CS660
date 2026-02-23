// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
// astro.config.mjs (snippet)
export default defineConfig({
  integrations: [
    starlight({
      title: 'NyxLang',
      sidebar: [
        { label: 'Overview', link: '/' },
        {
          label: 'Architecture',
          items: [
            { label: 'Overview', link: '/architecture/overview/' },
            { label: 'Pipeline', link: '/architecture/pipeline/' },
          ],
        },
        {
          label: 'Frontend',
          items: [
            { label: 'Lexer', link: '/frontend/lexer/' },
            { label: 'Parser', link: '/frontend/parser/' },
            { label: 'AST', link: '/frontend/ast/' },
          ],
        },
        {
          label: 'Semantic',
          items: [
            { label: 'Scope', link: '/semantic/scope/' },
            { label: 'Analysis', link: '/semantic/analysis/' },
          ],
        },
        {
          label: 'IR',
          items: [{ label: '3AC', link: '/ir/three-address-code/' }],
        },
        {
          label: 'Backend',
          items: [
            { label: 'RISC-V RV32', link: '/backend/riscv32/' },
            { label: 'Assembler', link: '/backend/assembler/' },
          ],
        },
        {
          label: 'Internals',
          items: [
            { label: 'Build System', link: '/internals/build-system/' },
            { label: 'Adding Features', link: '/internals/adding-features/' },
          ],
        },
      ],
    }),
  ],
});
