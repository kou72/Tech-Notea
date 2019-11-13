# Vim Bootstrap

Vim Bootstrapで雛形作成  
https://vim-bootstrap.com/  

ホームディレクトリに移動  
```mv ~/Downloads/generate.vim ~/.vimrc```

# ESLint, Prettier 追加

Prettier -> ESLint の順でfixするよう設定  

- .vimrc
```
call plug#begin(expand('~/.vim/plugged'))

Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

call plug#end()

" ale
let g:ale_linters = { '*': ['eslint'] }
let g:ale_fixers = { '*': ['prettier', 'eslint'] }
let g:ale_fix_on_save = 1
```
