" vimrc by @windvalley
" https://raw.githubusercontent.com/vimhack/dotfiles/master/vim/vimrc

" vim: set foldmarker={{,}} foldlevel=0 foldmethod=marker:
"
" 查看折叠内容的方法:
"    za: normal 模式下按 za, 表示当光标在关闭折叠上时打开之, 在打开折叠上时关闭之;
"        在打开的折叠内部任意处按 za, 也会关闭折叠.
"    zA: 是 za 的递归操作, 是针对嵌套折叠的场景.

" 安装步骤  Installation {{

" 一. 安装 Vim 及依赖
"
"    1. macOS 系统
"
"      1) 依赖安装
"
"      # 用于目录树文件图标显示的依赖安装
"      brew tap homebrew/cask-fonts && brew install font-hack-nerd-font
"
"      # 安装其他依赖
"      brew install cmake python mono go nodejs yarn
"      brew install ctags rg
"
"      2) Vim
"
"      brew install macvim
"
"      3) Neovim
"
"      brew install neovim
"      pip3 install neovim
"
"    2. Linux 系统
"
"      1) 依赖安装
"
"      # 用于目录树文件图标显示
"      mkdir -p ~/.local/share/fonts
"      cd ~/.local/share/fonts && \
"         curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" \
"         https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
"
"      2) Vim
"
"      sudo yum -y remove vim-common vim-enhanced vim-filesystem
"      sudo yum -y install gcc-c++ make ncurses ncurses-devel python3 ctags git
"      sudo yum -y install epel-release && yum -y install golang
"
"      # https://www.mono-project.com/download/stable/#download-lin-centos
"      sudo yum -y install mono-devel
"      curl -fsSL https://rpm.nodesource.com/setup_15.x | bash -
"      sudo yum -y install nodejs  # node & npm
"      sudo yum -y install tcl-devel ruby ruby-devel lua lua-devel luajit luajit-devel \
"         python3 python3-devel perl perl-devel perl-ExtUtils-ParseXS perl-ExtUtils-XSpp \
"         perl-ExtUtils-CBuilder perl-ExtUtils-Embed
"
"      git clone https://github.com/vim/vim.git
"      cd vim
"      ./configure --with-features=huge --enable-multibyte --enable-python3interp \
"         --enable-rubyinterp --enable-perlinterp --enable-luainterp
"      make && sudo make install
"
"      3) Neovim
"
"      # https://github.com/neovim/neovim/releases
"      sudo yum install -y neovim python3 nodejs
"
" 二. 配置步骤
"
"    1. Vim
"
"      1) 备份原配置文件 ~/.vimrc
"         mv ~/.vimrc ~/.vimrc.$(date +%F_%T)

"      2) 替换你的当前 ~/.vimrc 文件
"         curl -sfLo ~/.vimrc https://raw.githubusercontent.com/vimhack/dotfiles/master/vim/vimrc
"         curl --create-dirs -sfLo ~/.vim/coc-settings.json https://raw.githubusercontent.com/vimhack/dotfiles/master/vim/coc-settings.json

"    2. Neovim
"
"      1) 备份原配置文件 ~/.config/nvim/init.vim
"         mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.$(date +%F_%T)
"
"      2) 替换你的当前 ~/.config/nvim/init.vim 文件
"         curl --create-dirs -sfLo ~/.config/nvim/init.vim https://raw.githubusercontent.com/vimhack/dotfiles/master/vim/vimrc
"         curl -sfLo ~/.config/nvim/coc-settings.json https://raw.githubusercontent.com/vimhack/dotfiles/master/vim/coc-settings.json
"
" 三. 注意事项
"
"    * Vim 版本要求在 8.2+, 可通过 vim --version 查看.
"    * Neovim 版本要求在 0.4.0+, 可通过 nvim --version 查看.
"    * 对于 Vim, 为了支持 python3 和复制粘贴的便利, 需要 Vim 支持 python3 和 clipboard,
"      可通过`vim --version|grep -Eo '\+python3|\+clipboard'`查看是否有相关输出,
"      没有的话请重新编译安装.
"    * 本配置文件默认集成了 Go 开发插件 vim-go, 需要系统已经有 Go 环境.
"    * macOS 和 Linux 系统可正常使用, Windows 系统未测试.
"    * 按配置步骤配置完成后, 第一次打开 vim 或 nvim 会自动安装插件管理工具以及配置的众多插件,
"      安装完成后, 重新打开 vim/nvim 即可.
"    * Vim 和 Neovim 可同时安装在操作系统中, 共享 ~/.vim/ 目录下的插件.

" }}

" 基础环境  Basic Configuration {{

" 关闭兼容模式, 也就是不再兼容 VI, 必需放在第一行.
set nocompatible

" 设置 Vim 内部使用的字符编码, 默认值 latin1 或者操作系统 $LANG 环境变量对应的编码.
set encoding=utf-8
set fileencodings=utf8,ucs-bom,utf-8,cp936,latin1

" Vim 保存多少个历史命令, 一般保存在 ~/.viminfo 隐藏文件中.
set history=1000

" 如果过了这么多毫秒数以后还没有任何输入, 则把交换文件写入磁盘,
" 也用于 CursorHold 自动命令事件.
" 默认值: 4000(毫秒)
set updatetime=100

" 打开文件类型检测, 允许插件文件载入, 允许缩进文件载入.
filetype plugin indent on

" 重新设置 leader 键, 即一些自定义命令的前缀, 默认值: '\'
let mapleader = ','

" }}

" 插件安装  Plugins Installation {{

" vim-plug 安装与配置 {{
" doc: https://github.com/junegunn/vim-plug

" 自动安装用于管理 Vim/Neovim 众多插件的插件: vim-plug
if has('nvim')
  if !filereadable(expand('~/.config/nvim/autoload/plug.vim'))
    " 安装完 vim-plug 插件后, 自动清除下面的 echo 信息.
    set shortmess=aO

    echo "Downloading 'junegunn/vim-plug' to ~/.config/nvim/autoload/ for managing plugins,
      \ please wait..."

    silent !curl -sfLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  endif
else
  if !filereadable(expand('~/.vim/autoload/plug.vim'))
    " NOTE: 和如上 Neovim 不一样, Vim 这里不能直接使用 echo "",
    "   需要使用 silent !echo "" 的方式, 否则会提示如下交互信息:
    "   'Press ENTER or type command to continue'
    silent !echo "Downloading 'junegunn/vim-plug' to ~/.vim/autoload/ for managing plugins,
      \ please wait..."

    silent !curl -sfLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  endif
endif

" 启动 Vim/Neovim 时如果发现有配置了但还未安装的插件, 则自动安装.
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" 提供解除本配置文件中配置的默认插件的指令, 使用方法:
" 在 $HOME/.vimrc.plugins.local 中使用 UnPlug 'PluginRepoName'
function! s:plugRemove(plugin_repo)
  let plugin_repo = substitute(a:plugin_repo, '[\/]\+$', '', '')
  let plugin_name = fnamemodify(plugin_repo, ':t:s?\.git$??')
  call remove(g:plugs, plugin_name)
endfunction
command! -nargs=1 -bar UnPlug call s:plugRemove(<args>)

" }}

" 开始安装 Vim/Neovim 的众多插件,
" 可通过 command-line 模式 :help 插件名称 来查看相关插件的帮助文档.
" NOTE: 如果没有特别说明, 如下所有插件对 Vim 和 Neovim 均支持.
call plug#begin('~/.vim/plugged')

" 颜色主题  Colorschemes {{

" gruvbox
Plug 'morhetz/gruvbox'

" dracula
Plug 'dracula/vim', { 'as': 'dracula' }

" one: from Atom theme
Plug 'rakr/vim-one'

" iceberg
Plug 'cocopon/iceberg.vim'

" jellybeans
Plug 'nanotech/jellybeans.vim'

" base16-default-dark
Plug 'chriskempson/base16-vim'

" nord
Plug 'arcticicestudio/nord-vim'

" papercolor
Plug 'NLKNguyen/papercolor-theme'

" ayu
Plug 'ayu-theme/ayu-vim'

" tender
Plug 'jacoborus/tender.vim'

" rigel
Plug 'Rigellute/rigel'

" onehalf
Plug 'sonph/onehalf', { 'rtp': 'vim' }

" molokai
" 该版本解决了设置透明背景色时, 对于 Vim 部分关键字背景颜色没有变透明的问题,
" Neovim 不存在此问题.
Plug 'vimhack/molokai'

" monokai
Plug 'sickill/vim-monokai'

" vadelma
Plug 'severij/vadelma'

" pencil
Plug 'preservim/vim-colors-pencil'

" github
Plug 'cormacrelf/vim-colors-github'

" srcery
Plug 'srcery-colors/srcery-vim'

" solarized
Plug 'lifepillar/vim-solarized8'

" spring-night
Plug 'rhysd/vim-color-spring-night'

" primary
Plug 'google/vim-colorscheme-primary'

" embark
Plug 'embark-theme/vim', { 'as': 'embark' }

" no color: off
Plug 'pbrisbin/vim-colors-off'

" }}

" 代码补全  Code AutoCompletion {{

" 速度更快, 体验更优且支持更多编程语言的代码补全平台.
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" 为 coc-ultisnips 提供代码片段源.
Plug 'SirVer/ultisnips'

" 为 coc-snippets 提供代码片段源.
Plug 'honza/vim-snippets'

" 为 viml 脚本语言提供补全支持.
Plug 'Shougo/neco-vim'
Plug 'neoclide/coc-neco'

" 自动补全引号(单引号/双引号/反引号)、括号(小括号/中括号/大括号)的插件.
Plug 'Raimondi/delimitMate'

" 著名的 AI 补全插件 copilot(已收费).
" doc: https://copilot.github.com, https://docs.github.com/en/copilot/getting-started-with-github-copilot?tool=neovim
" Start Neovim and invoke :Copilot setup
" NOTE: 1. 首次安装需要等待官方授权才能使用.
" 2. 只支持 neovim 0.6+ 版本.
" 3. 没有任何补全提示的原因排查:
"    :help Copilot
"    :Copilot status
"    :Copilot log
" 4. 更新此插件, 可解决部分问题:
"    :PlugUpdate copilot.vim
" 5. 重新安装此插件可解决大部分问题, 方法:
"    先注释此行, 重新打开此文件, 执行 :PlugClean 进行卸载;
"    再取消注释, 执行 :PlugInstall 进行安装.
" Plug 'github/copilot.vim'

" 个人免费的AI补全插件, 可替代copilot.
" doc: https://github.com/Exafunction/codeium.vim
" NOTE: 1. Run `:Codeium Auth` to set up the plugin and start using Codeium;
" 2. Run `:help codeium` for a full list of commands and configuration options.
"Plug 'Exafunction/codeium.vim'

" }}

" 代码检查  Code Static Check {{

" 代码静态检查与自动修复插件: ALE(Asynchronous Lint Engine)
Plug 'dense-analysis/ale'

" }}

" 代码调试  Code Debug {{

" 代码 debug 插件
Plug 'puremourning/vimspector', {'do': './install_gadget.py
  \ --enable-c
  \ --enable-rust
  \ --enable-go
  \ --enable-python
  \ --enable-lua
  \ --enable-bash
  \ '}

" }}

" 编程语言  Programming Languages {{

" 为几乎所有语言提供语法高亮支持.
Plug 'sheerun/vim-polyglot'

"""""""" Go
" 搭建 Go 开发环境的 Vim 插件, 安装该插件的过程中,
" 会自动安装该插件依赖的大量 Go 二进制工具;
" 如果由于 Go 环境等问题导致自动安装失败,
" 可后续通过 command-line 模式安装 `:GoInstallBinaries`.
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" 自动为 Go 生成单元测试用例模版代码.
" 需提前安装 gotests 工具:
"   go get -u github.com/cweill/gotests/...
Plug 'buoto/gotests-vim'

"""""""" Rust
" https://github.com/rust-lang/rust.vim
Plug 'rust-lang/rust.vim'

" 帮助分析当前项目的依赖是否是最新的版本, 仅支持 Neovim.
Plug 'mhinz/vim-crates'

"""""""" openresty
" 提供 nginx/openresty 语法高亮与指令补全.
Plug 'spacewander/openresty-vim'

"""""""" javascript/html/css/vue/json
" 前端利器 html/css/js
Plug 'mattn/emmet-vim'

" 高亮 jsonc 类型文件, 有此插件就可以对 json 进行注释了.
Plug 'neoclide/jsonc.vim'

"""""""" markdown
" 通过浏览器实时预览 Markdown 文本的插件.
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}

" 在 markdown 中高效编辑表格.
Plug 'dhruvasagar/vim-table-mode'

"""""""" toml
" toml 语法高亮插件.
Plug 'cespare/vim-toml'

" }}

" 光标移动  Cursor Movement {{

" 光标高效跳转插件.
Plug 'easymotion/vim-easymotion'

" }}

" 文本编辑  Text Editing {{

" 多光标批量操作文本对象插件.
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" 代码注释插件.
Plug 'tpope/vim-commentary'
" 解决类似vue文件中存在多种语言场景的注释问题.
Plug 'suy/vim-context-commentstring'

" 使用指定符号包围光标所在单词, 比如:
" ys2w"  表示从光标位置开始的 2 个单词使用双引号包围.
"   ds"  normal 模式下删除光标周围的双引号.
"  cs"'  normal 模式下把光标所在周围的双引号替换为单引号.
Plug 'tpope/vim-surround'

" normal 模式下移动光标所在行, visual 模式下移动选择的行.
Plug 'matze/vim-move'

" 将代码从多行转换为单行或将单行转换为多行.
Plug 'AndrewRadev/splitjoin.vim'

" }}

" 文件浏览  File Navigation {{

" 目录树窗口插件.
Plug 'preservim/nerdtree'

" 快速打开想要的文件, 类似grep搜索文件内容等, 替代ctrlp插件.
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" 集成 ranger 文件管理器.
Plug 'francoiscabrol/ranger.vim'

" }}

" Git相关  Git Related {{

" 使目录树支持 git 的插件.
Plug 'Xuyuanp/nerdtree-git-plugin'

" 深度集成 git 的插件.
Plug 'tpope/vim-fugitive'

" git 历史版本的浏览插件, 该插件依赖 vim-fugitive 插件.
Plug 'junegunn/gv.vim'

" 显示光标所在内容的 git commit 信息, 方便了解代码背景.
Plug 'rhysd/git-messenger.vim'

" }}

" 用户接口  User Interface {{

" 提供开始界面.
" The fancy start screen for Vim.
Plug 'mhinz/vim-startify'

" 为正在编辑的文件生成大纲视图, 包括接口/方法/变量等,
" 可选中快速跳转, 适合单个文件代码较多的场景.
" 需要先在系统命令行安装 ctags, 比如如果是 macOS 系统, 则: brew install ctags
Plug 'majutsushi/tagbar'

" 美化状态栏插件.
Plug 'vimhack/lightline.vim'

" 为 lightline 插件提供显示 ale 检查出来的错误或警告的统计信息;
" 另外安装此插件可以解决 vim 打开文件同时显示目录树窗口的场景时,
" 无法正常加载 lightline 状态栏的问题.
Plug 'maximbaz/lightline-ale'

" 彩虹括号插件, 层级较多的括号场景使用不同颜色区分.
Plug 'luochen1990/rainbow'

" 悬浮终端插件.
Plug 'voldikss/vim-floaterm'

" 浏览源代码时, 进行上下文提示, 使能掌握当前代码所属位置.
Plug 'wellle/context.vim'

" 显示缩进线插件.
Plug 'Yggdroot/indentLine'

" 为行内跳转指令 f F t T 提供高亮字符显示.
Plug 'unblevable/quick-scope'

" 复制文本对象的时候, 高亮显示复制的文本对象.
Plug 'machakann/vim-highlightedyank'

" Vim 屏保 Matrix.
Plug 'uguu-org/vim-matrix-screensaver'

" 在文件内直接显示颜色代码所表示的颜色.
" NOTE: 该插件需要操作系统有 Go 环境.
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

" 为目录树、LeaderF、ranger、vim-startify 等插件显示文件类型.
" NOTE: 1) 需安装 nerd-fonts, 并设置终端模拟器的字体为相关字体.
" # doc: https://github.com/ryanoasis/nerd-fonts#font-installation
" 2) 此插件要安装在目录树、LeaderF 等插件的后面.
Plug 'ryanoasis/vim-devicons'

" 在 vim-devicons 插件的基础上, 根据文件类型的不同, 改变图标的颜色.
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" }}

" 其他  Others  {{

" 异步任务插件.
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'

" 对 Vim 主题配色方案进行调整时, 可使用此工具获取光标下标识符当前配色方案的详细信息.
Plug 'vim-scripts/SyntaxAttr.vim'

" 日历插件.
Plug 'itchyny/calendar.vim'

" 在 .tmux.conf 中直接通过 K 查看 tmux 文档等功能.
Plug 'tmux-plugins/vim-tmux'

" Vim 从菜鸟到高手之路必备, 禁止连续按 jkhl 等低效操作,
" 强制你根据不同场景来思考使用更高效的命令的习惯.
Plug 'takac/vim-hardtime'

" Vim 作者 Bram 写的一个小游戏, 用于演示 Vim8.2 的几个新功能.
" NOTE: :Kill 启动游戏, 按说明玩既可, 只支持 Vim8.2+, 不支持 Neovim.
Plug 'vim/killersheep'

" }}

" 加载自定义插件的配置文件.
let vimrc_plugins_local = $HOME . '/.vimrc.plugins.local'
if filereadable(expand(vimrc_plugins_local))
  exec 'source' vimrc_plugins_local
endif

" 最后 command-line 模式下执行 :PlugInstall 自动安装上面未安装的插件, 其他常用命令:
"    :PlugStatus   查看当前状态, 安装进度等;
"    :PlugUpdate   更新所有插件, 建议定期更新所有插件;
"    :PlugClean    卸载插件, 需要先在上面注释掉或删除相关插件,
"                  然后重新打开此文件或 normal 模式下按 ,R 执行此命令;
"    :PlugUpgrade  更新 vim-plug 本身.
call plug#end()

" }}

" 状态栏定制  Statusline&Tabline Customization {{

"""""" itchyny/lightline.vim
" doc: https://github.com/itchyny/lightline.vim

if &rtp =~ '/lightline.vim'
  " 本选项的值影响最后一个窗口何时有状态行:
  "     0: 永不
  "     1: 只有在有至少两个窗口时
  "     2: 总是
  " 默认值: 1, 为了单窗口也可以显示状态栏, 此处设置为2.
  set laststatus=2

  " 指定何时显示页面标签, 默认值: 1
  "   0: 永远不会
  "   1: 至少有两个标签页时才会
  "   2: 永远会
  set showtabline=1

  " 由于此插件已经帮我们美化显示了当前的 Vim 模式, 所以 Vim 自带的模式显示可以去除.
  set noshowmode

  let g:lightline = {}
endif

"""""" 'maximbaz/lightline-ale'
" doc: https://github.com/maximbaz/lightline-ale

if &rtp =~ '/lightline-ale,'
  " 美化错误与警告等信息的显示图标.
  let g:lightline#ale#indicator_checking = "\uf110"
  let g:lightline#ale#indicator_ok = "\uf00c"

  " 以下三条指令的字符串值结尾多一个空格, 用来解决图标和数字重叠的问题.
  let g:lightline#ale#indicator_infos = "\uf129 "
  let g:lightline#ale#indicator_warnings = "\uf071 "
  let g:lightline#ale#indicator_errors = "\uf05e "

  let g:lightline.component_expand = {
    \  'linter_checking': 'lightline#ale#checking',
    \  'linter_infos': 'lightline#ale#infos',
    \  'linter_warnings': 'lightline#ale#warnings',
    \  'linter_errors': 'lightline#ale#errors',
    \  'linter_ok': 'lightline#ale#ok',
    \ }

  let g:lightline.component_type = {
    \  'linter_checking': 'right',
    \  'linter_infos': 'right',
    \  'linter_warnings': 'warning',
    \  'linter_errors': 'error',
    \  'linter_ok': 'right',
    \ }

  " 已从 left 中去除 cocstatus, 可选择性加入.
  let g:lightline.active = {
    \  'left': [ [ 'mode', 'paste' ],
    \            [ 'git', 'bgit', 'method', 'readonly', 'filename', 'modified' ],
    \            [ 'codeium' ],
    \  ],
    \  'right': [ [ 'lineinfo' ],
    \             [ 'percent' ],
    \             [ 'fileformat', 'fileencoding', 'filetype' ],
    \             [ 'linter_checking', 'linter_errors', 'linter_warnings',
    \               'linter_infos', 'linter_ok' ],
    \             [ 'blame' ],
    \  ],
    \ }

  let g:lightline.component_function = {
    \  'cocstatus': 'coc#status',
    \  'git': 'LightlineGitStatus',
    \  'bgit': 'LightlineBufferGitStatus',
    \  'blame': 'LightlineGitBlame',
    \  'codeium': 'codeium#GetStatusString',
    \ }

  " 如果状态栏内容过多, 从右侧砍掉部分内容.
  let g:lightline.component = {
    \  'lineinfo': '%3l:%-2v%<',
    \ }

  " doc: https://github.com/neoclide/coc-git
  "   *  表示 git 仓库内容有变更;
  "   x  表示 git 仓库内容有冲突;
  "   ●  表示 git 新增或变化内容已经提交到暂存区;
  "   …  表示 git 仓库内有未跟踪的新文件;
  "   以上符号可同时在分支后显示, 如果分支名称后没有任何上述符号, 说明分支是干净的.
  function! LightlineGitStatus() abort
    let gstatus = get(g:, 'coc_git_status', '')
    return gstatus
  endfunction

  function! LightlineBufferGitStatus() abort
    let gbstatus = get(b:, 'coc_git_status', '')
    return gbstatus
  endfunction

  function! LightlineGitBlame() abort
    let blame = get(b:, 'coc_git_blame', '')

    " 窗口宽度大于120时, 状态栏才显示 git blame 信息.
    return winwidth(0) > 120 ? blame : ''
  endfunction
endif

"""""" 状态栏和标签页栏的使用图标进行美化

" 在状态栏添加文件类型和文件格式图标.
let g:lightline.component_function.filetype = 'MyFiletype'
let g:lightline.component_function.fileformat = 'MyFileformat'

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype
    \ . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

let g:lightline.tab_component_function = {
  \ 'modified': 'LightlineTablineModified',
  \ 'tabnum': 'LightlineTablineWebDevIcons',
  \ }

" 标签页数字自定义.
let g:tabnum_map = {
  \ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
  \ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹',
  \ 10: '¹⁰', 11: '¹¹', 12: '¹²', 13: '¹³',
  \ 14: '¹⁴', 15: '¹⁵', 16: '¹⁶', 17: '¹⁷',
  \ 18: '¹⁸', 19: '¹⁹', 20: '²⁰', 21: '²¹',
  \ }

" 标签页显示当前文件类型图标和标签序号.
function! LightlineTablineWebDevIcons(n)
  let l:bufnr = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
  return g:tabnum_map[a:n] . " " . WebDevIconsGetFileTypeSymbol(bufname(l:bufnr))
endfunction

" 标签页使用自定义图标表示正在修改、禁止修改和只读状态.
let s:modified_icon = '✎'
let s:unmodifiable_icon = ''
let s:readonly_icon = ''

function! LightlineTablineModified(n)
  let l:window_number = tabpagewinnr(a:n, '$')
  let l:modified = v:false
  let l:unmodifiable = v:true
  let l:readonly = v:true
  for winnr in range(1, l:window_number)
    let l:modified = l:modified || gettabwinvar(a:n, winnr, '&modified')
    let l:unmodifiable = l:unmodifiable && !gettabwinvar(a:n, winnr, '&modifiable')
    let l:readonly = l:readonly && gettabwinvar(a:n, winnr, '&readonly')
  endfor
  let l:string = ''
  if l:unmodifiable
    let l:string = s:unmodifiable_icon
  elseif l:readonly
    let l:string = s:readonly_icon
  endif
  if l:modified
    if l:string != ""
      let l:string = l:string . " " . s:modified_icon
    else
      let l:string = s:modified_icon
    endif
  endif
  return l:string
endfunction

" }}

" 主题定制  Colorscheme Customization {{
"
" 优秀的颜色主题方案:
"   dracula: https://draculatheme.com/vim
"   rigel: https://github.com/Rigellute/rigel
"   gruvbox: https://github.com/morhetz/gruvbox
"   molokai: https://github.com/tomasr/molokai
"   monokai: https://github.com/sickill/vim-monokai
"   one: https://github.com/rakr/vim-one
"   iceberg: https://github.com/cocopon/iceberg.vim
"   jellybeans: https://github.com/nanotech/jellybeans.vim
"   nord: https://github.com/arcticicestudio/nord-vim
"   tender: https://github.com/jacoborus/tender.vim
"   papercolor: https://github.com/NLKNguyen/papercolor-theme
"   ayu: https://github.com/ayu-theme/ayu-vim
"   onehalf: https://github.com/sonph/onehalf
"   vadelma: https://github.com/severij/vadelma
"   pencil: https://github.com/preservim/vim-colors-pencil
"   github: https://github.com/cormacrelf/vim-colors-github
"   srcery: https://github.com/srcery-colors/srcery-vim
"   solarized8: https://github.com/lifepillar/vim-solarized8
"   spring-night: https://github.com/rhysd/vim-color-spring-night
"   primary: https://github.com/google/vim-colorscheme-primary
"   base16-*: https://github.com/chriskempson/base16-vim
"   embark: https://github.com/embark-theme/vim
"   off: https://github.com/pbrisbin/vim-colors-off
"
" NOTE: 使用颜色主题(colorscheme), 同时请将终端也设置成对应的主题, 这样才能获得更好的视觉效果.

" 代码高亮显示.
syntax enable

" 如果当前 vim/neovim 版本支持 termguicolors, 则启用 24bit 真彩;
" 启用 termguicolors 后, 将使用 guifg/guibg 配置的色彩方案,
" 也就是说在色彩方面把终端当图形界面一样看待.
"
" for Linux/Unix
if has ('termguicolors') && ($COLORTERM == 'truecolor' || $COLORTERM == '24bit')
  set termguicolors
endif
" for Windows
if has('vcon')
  set termguicolors
endif

" 当 g:enable_bg_transparent 等于 1 时, 是否使 popup window 背景变透明, 1 为开启, 0 为关闭.
" NOTE: 变更效果涉及到 coc.nvim 命令补全的弹出窗口, 文档查看窗口等.
let g:popup_window_transparent=0

" 解决 Vim 在 cterm 彩色终端下不支持斜体字的问题, Neovim 没有此问题.
" 解决方法来源: https://rsapkf.xyz/blog/enabling-italics-vim-tmux
" NOTE: ^[ 必须通过 <Ctrl-v><Esc> 敲出来才可以.
set t_ZH=[3m
set t_ZR=[23m

" *** colorschemes 优化方法集合 ***
"
" NOTE: 方法结尾是 Before 的代表需要放在 colorscheme 指令之前执行;
" 方法结尾是 After 的代表需要放在 colorscheme 指令之后执行.

" 通用方法 {{

function! Colorscheme()
  " 加载单独的用于设置 colorscheme 的文件, 设置该文件的目的是当变更颜色方案时,
  " dotfiles git 仓库可以不被无用的变更信息干扰.
  let colorscheme_file = expand('~/.vim/colorscheme.vim')

  if filereadable(colorscheme_file)
    exec 'source' colorscheme_file
  else
    " 默认的背景色, dark or light.
    set background=dark

    " 使用 try 的方式捕获并忽略错误, 来实现消除第一次使用此配置文件时的没用报错信息.
    try
      " 设置默认主题.
      colorscheme dracula
    catch /Cannot find color scheme 'dracula'/
    endtry
  endif
endfunction

" 是否启用 Vim/Neovim 透明背景色的功能, 从单独的配置文件读取相关变量值来控制;
" 从单独的配置文件读取是为了变更时, 不会干扰到 dotfiles 仓库.
function! ToggleVimTransparentBgFeature()
  let bg_transparent_file = expand('~/.vim/bg_transparent.vim')
  if filereadable(bg_transparent_file)
    exec 'source' bg_transparent_file
  else
    " 值为 1 表示启用 Vim/Neovim 背景透明, 0 为禁用.
    " 默认值: 1
    let g:enable_bg_transparent=1
  endif
endfunction

" 支持斜体字的方法, 对于不支持斜体字或支持的不太理想的 colorscheme,
" 可以使用此方法提供支持或优化.
function! EnableItalic()
  hi Comment cterm=italic gui=italic
  hi Todo cterm=italic gui=italic
  hi Folded cterm=italic gui=italic
  hi Special cterm=italic gui=italic
  hi String cterm=italic gui=italic
  hi SpellCap cterm=italic gui=italic
  hi htmlBoldItalic cterm=italic gui=italic
  hi htmlBoldUnderlineItalic cterm=italic gui=italic
  hi htmlUnderlineItalic cterm=italic gui=italic
  hi htmlItalic cterm=italic gui=italic
  hi vimCommentTitle cterm=italic gui=italic
  hi markdownItalic cterm=italic gui=italic
endfunction

" 支持粗体的方法.
function! EnableBold()
  hi Function cterm=bold gui=bold
  hi Title cterm=bold gui=bold
  hi htmlBold cterm=bold gui=bold
  hi markdownBold cterm=bold gui=bold

  hi! link zshFunction Function

  if (g:colors_name == 'PaperColor')
    hi goFunction cterm=bold gui=bold
    hi pythonFunction cterm=bold gui=bold
    hi shFunction cterm=bold gui=bold
    hi! link zshFunction shFunction
    hi Type cterm=NONE gui=NONE
  elseif (g:colors_name == 'one')
    hi pythonFunction cterm=bold gui=bold
  elseif (g:colors_name == 'pencil')
    hi Function cterm=bold guifg=#008EC4 gui=bold
  endif
endfunction

" 设置提示列的颜色方案, 去掉默认的背景色,
" 比如 ale 插件的代码静态检查的错误或警告信息就会出现在此列,
" coc-git 扩展的文件变化信息也会出现在此列.
function! SignColumnHi()
  hi SignColumn cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
endfunction

" 优化 ale 错误提示标识的颜色方案.
function! ALESignHi()
  if &background == 'dark'
    hi ALEErrorSign cterm=NONE ctermbg=NONE ctermfg=DarkRed guibg=NONE guifg=DarkRed
    hi ALEWarningSign cterm=NONE ctermbg=NONE ctermfg=DarkYellow guibg=NONE guifg=DarkYellow
  else
    hi ALEErrorSign cterm=NONE ctermbg=NONE ctermfg=Red guibg=NONE guifg=Red
    hi ALEWarningSign cterm=NONE ctermbg=NONE ctermfg=208 guibg=NONE guifg=#ff8700
  endif
endfunction

" 为 coc-git 插件提供 git 增删改提示标识的高亮颜色方案.
" NOTE: 必须放在颜色主题设置的后面才有效果.
function! GitSignHi()
  hi GitAddSign    guifg=SeaGreen ctermfg=2
  hi GitChangeSign guifg=DarkYellow ctermfg=3
  hi GitDeleteSign guifg=DarkRed ctermfg=1
  hi GitTopDeleteSign guifg=Red ctermfg=1*
  hi GitChangeDeleteSign guifg=LightRed ctermfg=1*
endfunction

" 重新加载 lightline 状态栏的方法.
function! LightlineReload()
  " 这部分分支语句用于切换背景色时, 重新加载 lightline.
  if g:colors_name == 'gruvbox'
    execute "source " . g:plug_home .
      \ "/gruvbox/autoload/lightline/colorscheme/gruvbox.vim"
  elseif g:colors_name == 'iceberg'
    execute "source " . g:plug_home .
      \ "/iceberg.vim/autoload/lightline/colorscheme/iceberg.vim"
  elseif g:colors_name == 'one'
    execute "source " . g:plug_home .
      \ "/lightline.vim/autoload/lightline/colorscheme/one.vim"
  elseif g:colors_name =~ 'onehalf'
    execute "source " . g:plug_home .
      \ "/lightline.vim/autoload/lightline/colorscheme/onehalf.vim"
  elseif g:colors_name =~ 'base16-atelier-dune'
    execute "source " . g:plug_home .
      \ "/lightline.vim/autoload/lightline/colorscheme/base16_atelier_dune.vim"
  elseif g:colors_name == 'vadelma'
    execute "source " . g:plug_home .
      \ "/lightline.vim/autoload/lightline/colorscheme/vadelma_new.vim"
  elseif g:colors_name == 'PaperColor'
    execute "source " . g:plug_home .
      \ "/lightline.vim/autoload/lightline/colorscheme/papercolor_new.vim"
  elseif g:colors_name == 'github'
    execute 'source ' . g:plug_home .
      \ '/vim-colors-github/autoload/lightline/colorscheme/github.vim'
  elseif g:colors_name == 'solarized8'
    execute 'source ' . g:plug_home .
      \ '/lightline.vim/autoload/lightline/colorscheme/solarized8.vim'
  elseif g:colors_name == 'primary'
    execute 'source ' . g:plug_home .
      \ '/lightline.vim/autoload/lightline/colorscheme/primary.vim'
  elseif g:colors_name == 'pencil'
    execute 'source ' . g:plug_home .
      \ '/lightline.vim/autoload/lightline/colorscheme/pencil.vim'
  elseif g:colors_name == 'off'
    execute 'source ' . g:plug_home .
      \ '/lightline.vim/autoload/lightline/colorscheme/off.vim'
  endif

  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

function! BackgroundTransparency()
  " 使 vim/nvim 背景透明.
  hi! Normal ctermbg=NONE guibg=NONE

  " 解决没有文字内容的底部区域无法使背景透明的问题.
  " NOTE: 不能对所有 colorscheme 都使用这种方式, 会对配色造成干扰, 比如 gruvbox.
  if g:colors_name == 'github' ||
    \ g:colors_name == 'jellybeans' ||
    \ g:colors_name == 'PaperColor' ||
    \ g:colors_name == 'primary' ||
    \ g:colors_name == 'monokai'

    hi! NonText ctermbg=NONE guibg=NONE
  endif

  if (g:popup_window_transparent == 1)
    " 使悬浮窗口透明.
    hi Pmenu ctermbg=NONE guibg=NONE
  endif

  " 自定义行号颜色, 使所有颜色主题使用相同行号颜色方案, 默认不启用.
  " NOTE: Vim 识别三种不同的终端, term 黑白终端, cterm 彩色终端, gui Gvim 窗口.
  let linenr_colorscheme_custom=0
  if (linenr_colorscheme_custom==1)
    hi LineNr cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=NONE
  endif
endfunction

" 设置背景透明的方法, 需要放到 colorscheme 指令之后执行.
function! BGTransparentAfter()
  if (g:enable_bg_transparent == 1)
    call BackgroundTransparency()
  endif
endfunction

" 在背景透明和不透明之间切换的方法.
function! ToggleBGTransparent()
  if g:enable_bg_transparent == 1
    let &background = &background
    let g:enable_bg_transparent = 0

    if g:colors_name == 'PaperColor'
      call PaperColorBefore()
      execute 'colorscheme ' . g:colors_name
      call PaperColorAfter()
    elseif g:colors_name == 'jellybeans'
      let g:jellybeans_overrides = {}
      call JellybeansBefore()
      execute 'colorscheme ' . g:colors_name
      call JellybeansAfter()
    elseif g:colors_name == 'rigel'
      call RigelAfter()
    elseif g:colors_name == 'dracula'
      call DraculaAfter()
    elseif g:colors_name == 'gruvbox'
      call GruvboxAfter()
    elseif g:colors_name == 'iceberg'
      call IcebergAfter()
    elseif g:colors_name == 'vadelma'
      call VadelmaAfter()
    elseif g:colors_name == 'nord'
      call NordAfter()
    elseif g:colors_name == 'tender'
      call TenderAfter()
    elseif g:colors_name == 'pencil'
      call PencilAfter()
    elseif g:colors_name == 'ayu'
      call AyuAfter()
    elseif g:colors_name == 'molokai'
      call MolokaiBefore()
      execute 'colorscheme ' . g:colors_name
      call MolokaiAfter()
    elseif g:colors_name == 'monokai'
      call MonokaiAfter()
    elseif g:colors_name == 'base16-default-dark'
      call Base16DefaultDarkAfter()
    elseif g:colors_name == 'github'
      call GithubAfter()
    elseif g:colors_name == 'solarized8'
      call SolarizedAfter()
    elseif g:colors_name == 'srcery'
      call SrceryAfter()
    elseif g:colors_name == 'spring-night'
      call SpringNightAfter()
    elseif g:colors_name == 'primary'
      call GooglePrimaryAfter()
    elseif g:colors_name == 'base16-flat'
      call Base16FlatAfter()
    elseif g:colors_name == 'base16-cupertino'
      call Base16CupertinoAfter()
    elseif g:colors_name == 'base16-materia'
      call Base16MateriaAfter()
    elseif g:colors_name =~ 'onehalf'
      call OnehalfAfter()
    elseif g:colors_name =~ 'base16-atelier-dune'
      call Base16AtelierDuneAfter()
    elseif g:colors_name == 'base16-oceanicnext'
      call Base16OceanicnextAfter()
    elseif g:colors_name == 'embark'
      call EmbarkAfter()
    elseif g:colors_name == 'off'
      call OffAfter()
    endif
  else
    call BackgroundTransparency()
    let g:enable_bg_transparent = 1
  endif

  " 解决在切换背景透明色后, SignColumn/ALESign/GitSign 失去原有颜色方案的问题.
  call SignColumnHi()
  call ALESignHi()
  call GitSignHi()
endfunction

" 在背景是 dark 和 light 之间切换的方法.
function! ToggleBGColor()
  " 对于不支持切换背景色为 light 的 colorschemes, 给出提示信息.
  if g:colors_name == 'ayu' ||
    \ g:colors_name == 'dracula' ||
    \ g:colors_name == 'jellybeans' ||
    \ g:colors_name == 'molokai' ||
    \ g:colors_name == 'monokai' ||
    \ g:colors_name == 'rigel' ||
    \ g:colors_name == 'tender' ||
    \ g:colors_name == 'nord' ||
    \ g:colors_name == 'base16-default-dark' ||
    \ g:colors_name == 'srcery' ||
    \ g:colors_name == 'spring-night' ||
    \ g:colors_name == 'base16-flat' ||
    \ g:colors_name == 'base16-materia' ||
    \ g:colors_name == 'base16-oceanicnext' ||
    \ g:colors_name == 'embark'

    echo g:colors_name . " has no light colorscheme"
    return
  endif

  " 对于不支持切换背景色为 dark 的 colorschemes, 给出提示信息.
  if g:colors_name == 'base16-cupertino'
    echo g:colors_name . " has no dark colorscheme"
    return
  endif

  " 由于 onehalfdark 和 onehalflight 不使用 background 选项来控制背景色, 故需单独配置.
  if g:colors_name == 'onehalfdark'
    colorscheme onehalflight
    call OnehalfAfter()
  elseif g:colors_name == 'onehalflight'
    colorscheme onehalfdark
    call OnehalfAfter()
  elseif g:colors_name == 'base16-atelier-dune'
    colorscheme base16-atelier-dune-light
    call Base16AtelierDuneAfter()
  elseif g:colors_name == 'base16-atelier-dune-light'
    colorscheme base16-atelier-dune
    call Base16AtelierDuneAfter()
  else
    " 其他主题设置切换背景颜色.
    let &background = ( &background ==# 'dark' ? 'light' : 'dark' )
  endif

  if g:colors_name == 'PaperColor'
    let g:PaperColor_Theme_Options.theme.default.transparent_background = 0
    execute 'colorscheme ' . g:colors_name
    call PaperColorAfter()
  elseif g:colors_name == 'gruvbox'
    call GruvboxAfter()
  elseif g:colors_name == 'vadelma'
    call VadelmaAfter()
  elseif g:colors_name == 'github'
    call GithubAfter()
  elseif g:colors_name == 'pencil'
    call PencilAfter()
  elseif g:colors_name == 'solarized8'
    call SolarizedAfter()
  elseif g:colors_name == 'iceberg'
    call IcebergAfter()
  elseif g:colors_name == 'primary'
    call GooglePrimaryAfter()
  elseif g:colors_name == 'off'
    call OffAfter()
  endif

  " 重载 lightline 状态栏, 使其颜色随着背景色改变.
  call LightlineReload()

  " 解决从透明背景的场景切换背景颜色后, 需要连续按两次 ,v 才能切换成背景透明的问题.
  let g:enable_bg_transparent = 0

  " 解决在变换背景颜色后, SignColumn/ALESign/GitSign 失去原有颜色方案的问题.
  call SignColumnHi()
  call ALESignHi()
  call GitSignHi()
endfunction

" }}

" 需要放置到 colorscheme 指令之前的主题优化方法 {{

function! NordBefore()
  let g:nord_italic = 1
  let g:nord_italic_comments = 1
endfunction

function! MolokaiBefore()
  " 需要设置成 0, 否则对于 vim, 当背景是透明时部分关键字背景是黑色的.
  let g:molokai_italic = 0
endfunction

function! GruvboxBefore()
  " 调整 gruvbox 主题的颜色对比度.
  " from: https://github.com/morhetz/gruvbox/wiki/Troubleshooting
  " 默认值: medium, 可选值: soft, medium, hard
  let g:gruvbox_contrast_dark = 'medium'
  let g:gruvbox_contrast_light = 'hard'

  " 是否启用粗体字, 0 为禁用, 1 为启用, 默认值: 1
  let g:gruvbox_bold = 1

  " 是否启用斜体字, 默认值: 0
  let g:gruvbox_italic = 1

  " 对于代码中的字符串是否启用斜体字, 默认值: 0
  let g:gruvbox_italicize_strings = 1

  " 注释内容是否启用斜体字, 默认值: 1
  let g:gruvbox_italicize_comments = 1
endfunction

function! DraculaBefore()
  " 是否启用斜体字, 默认值: 1
  let g:dracula_italic=1

  " 是否启用粗体字, 默认值: 1
  let g:dracula_bold=1
endfunction

function! JellybeansBefore()
  " 是否禁用斜体字, 0 禁用, 1 启用.
  let g:jellybeans_use_term_italics = 1
  let g:jellybeans_use_gui_italics = 1
endfunction

function! PaperColorBefore()
  " papercolor 主题设置:
  " 是否允许粗体字, 1 是允许, 0 是不允许.
  let g:PaperColor_Theme_Options = {
    \  'theme': {
    \    'default': {
    \      'allow_bold': 0,
    \     }
    \   }
    \ }
  " 是否允许斜体字, 1 是允许, 0 是不允许.
  let g:PaperColor_Theme_Options.theme.default.allow_italic = 1
endfunction

function! PencilBefore()
  " 0=low (def), 1=high
  let g:pencil_higher_contrast_ui = 0
  " 0=blue (def), 1=normal
  let g:pencil_neutral_headings = 1
  " 0=gray (def), 1=normal
  let g:pencil_neutral_code_bg = 0
endfunction

function! GithubBefore()
  " 使 github_light 的白色背景看上去更灰一些.
  let g:github_colors_soft = 1
endfunction

function! SrceryBefore()
  let g:srcery_italic = 1
  let g:srcery_bold = 1
  let g:srcery_underline = 1
  let g:srcery_undercurl = 1
  let g:srcery_hard_black_terminal_bg = 0
endfunction

function! SolarizedBefore()
  " 可选值: normal(default), low, high
  let g:solarized_visibility = 'high'
  let g:solarized_diffmode = 'normal'
endfunction

" }}

" 需要放置到 colorscheme 指令之后的主题优化方法 {{

function! DraculaAfter()
  " 设置 popup window 背景透明色后, 使用 vim 时, 在进行代码提示的时候,
  " dracula 主题的字体颜色变得很难辨认, 这里进行优化, nvim 无此问题.
  if !has('nvim') && (g:colors_name == 'dracula') && (g:popup_window_transparent == 1)
    hi Pmenu ctermbg=NONE guibg=NONE ctermfg=white
  endif

  let g:lightline.colorscheme = 'dracula'

  " 优化第 80 列的颜色方案.
  hi ColorColumn cterm=NONE ctermbg=237 guibg=#44475a

  " 优化非可见字符 nbsp, tab, trail 等的颜色方案:
  " 目的是改变 tab 键和行尾空格的颜色样式, 从而方便我们明显的看到多余的空白字符.
  " NOTE: 对于 Vim, 是由 SpecialKey 高亮组定义的,
  " 但对于 Neovim, 则是由 Whitespace 高亮组定义的.
  hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=237 guibg=NONE guifg=#44475a
  hi Whitespace cterm=NONE ctermbg=NONE ctermfg=237 guibg=NONE guifg=#44475a

  " 优化缩进线的颜色方案.
  hi Conceal cterm=NONE ctermbg=NONE ctermfg=237 guibg=NONE guifg=#44475a
endfunction

function! VadelmaAfter()
  let g:lightline.colorscheme = 'vadelma_new'

  if &background == 'dark'
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#444444
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#444444
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#444444
  else
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=253 guibg=NONE guifg=#dadada
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=253 guibg=NONE guifg=#dadada
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=253 guibg=NONE guifg=#dadada
  endif

  call EnableItalic()
  call EnableBold()
endfunc

function! PaperColorAfter()
  let g:lightline.colorscheme = 'papercolor_new'

  if &background == 'dark'
    " 优化光标所在行的行号颜色.
    hi CursorLineNr cterm=NONE ctermbg=NONE ctermfg=DarkYellow guibg=NONE guifg=DarkYellow

    " cterm=NONE 表示用来去掉默认的粗体显示.
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#444444
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#444444
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#444444
  else
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=251 guibg=NONE guifg=#c6c6c6
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=251 guibg=NONE guifg=#c6c6c6
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=251 guibg=NONE guifg=#c6c6c6
  endif

  call EnableItalic()
  call EnableBold()
endfunction

function! JellybeansAfter()
    let g:lightline.colorscheme = 'jellybeans'

    hi SpecialKey ctermbg=NONE ctermfg=237 guibg=NONE guifg=#3a3a3a
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=237 guibg=NONE guifg=#3a3a3a
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=237 guibg=NONE guifg=#3a3a3a

    hi ColorColumn ctermbg=236 guibg=#303030

    hi CursorLine cterm=NONE ctermbg=236 ctermfg=NONE guibg=#303030 guifg=NONE
    hi Cursorcolumn cterm=NONE ctermbg=236 ctermfg=NONE guibg=#303030 guifg=NONE

    call EnableItalic()
    call EnableBold()
endfunction

function! Base16DefaultDarkAfter()
  let g:lightline.colorscheme = 'base16_default_dark'

  hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#444444
  hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#444444
  hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#444444

  call EnableItalic()
  call EnableBold()
endfunction

function! RigelAfter()
  " 定制状态栏的主题颜色.
  let g:rigel_lightline = 1
  let g:lightline.colorscheme = 'rigel'

  hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#00384d
  hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#00384d
  hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#00384d

  " 优化 ColorColumn 列的颜色方案.
  " NOTE: 设置 ctermbg 对 vim 有效, 对 nvim 无效, 设置 guibg 才对 nvim 有效.
  hi ColorColumn cterm=NONE ctermbg=black guibg=#00384d

  " 优化光标所在行的颜色方案.
  hi CursorLine cterm=NONE ctermbg=black ctermfg=NONE guibg=#00384d guifg=NONE

  " 优化光标所在列的颜色方案.
  hi Cursorcolumn cterm=NONE ctermbg=black ctermfg=NONE guibg=#00384d guifg=NONE

  " 优化光标所在行的行号的颜色方案.
  hi CursorLineNr cterm=NONE ctermbg=NONE ctermfg=white guibg=#00384d guifg=#afffff

  call EnableItalic()
  call EnableBold()
endfunction

function! OneAfter()
  let g:lightline.colorscheme = 'one'

  if &background == 'dark'
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=16 guibg=NONE guifg=#3b4048
  else
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=251 guibg=NONE guifg=#d3d3d3
  endif

  call EnableItalic()
  call EnableBold()
endfunction

function! MolokaiAfter()
  let g:lightline.colorscheme = 'molokai'

  " for Neovim, 通过 cterm=NONE 来去掉默认的粗体显示.
  hi Whitespace cterm=NONE guibg=NONE guifg=#465457
  hi Conceal cterm=NONE guibg=NONE guifg=#465457

  call EnableItalic()
  call EnableBold()
endfunction

function! GruvboxAfter()
  let g:lightline.colorscheme = 'gruvbox'

  if &background == 'dark'
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=250 guibg=NONE guifg=#504945
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=250 guibg=NONE guifg=#504945
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=250 guibg=NONE guifg=#504945
  else
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=250 guibg=NONE guifg=#d5c4a1
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=250 guibg=NONE guifg=#d5c4a1
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=250 guibg=NONE guifg=#d5c4a1
  endif

  if !has('nvim')
    " 解决使用 vim 打开 markdown 类型文件, 部分内容背景颜色是黑色的问题.
    " 比如: **example**
    hi HtmlBold gui=bold guibg=NONE guifg=#ebdbb2
    hi Todo gui=italic guibg=NONE guifg=#ebdbb2
  endif

  call EnableItalic()
endfunction

function! IcebergAfter()
  let g:lightline.colorscheme = 'iceberg'

  if &background == 'dark'
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=240 guibg=NONE guifg=#515e97
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=240 guibg=NONE guifg=#515e97
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=240 guibg=NONE guifg=#515e97
  else
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=248 guibg=NONE guifg=#a5b0d3
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=248 guibg=NONE guifg=#a5b0d3
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=248 guibg=NONE guifg=#a5b0d3
  endif

  call EnableItalic()
  call EnableBold()
endfunction

function! NordAfter()
  let g:lightline.colorscheme = 'nord'

  hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=250 guibg=NONE guifg=#4C566A
  hi Whitespace cterm=NONE ctermbg=NONE ctermfg=250 guibg=NONE guifg=#4C566A
  hi Conceal cterm=NONE ctermbg=NONE ctermfg=250 guibg=NONE guifg=#4C566A

  " nord 默认提供的斜体字支持不够理想, 使用自定义方法增强.
  call EnableItalic()
  call EnableBold()
endfunction

function! TenderAfter()
  let g:lightline.colorscheme = 'tender_new'

  hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#293b4d
  hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#293b4d
  hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#293b4d

  call EnableItalic()
  call EnableBold()
endfunction

function! AyuAfter()
  if (g:ayucolor == 'dark')
    let g:lightline.colorscheme = 'ayu_dark'

    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#253340
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#253340
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#253340
  elseif (g:ayucolor == 'mirage')
    let g:lightline.colorscheme = 'ayu_mirage'

    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#343F4C
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#343F4C
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#343F4C
  else
    let g:lightline.colorscheme = 'ayu_light'

    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#F0EEE4
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#F0EEE4
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#F0EEE4
  endif

  call EnableItalic()
  call EnableBold()
endfunction

function! OnehalfAfter()
  let g:lightline.colorscheme = 'onehalf'

  if &background == 'dark'
    " 此主题默认弹窗是 light 的, 这里改成 dark.
    hi Pmenu guibg=#313640 guifg=#dcdfe4

    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#474e5d
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#474e5d
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#474e5d
  else
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#d4d4d4
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#d4d4d4
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#d4d4d4
  endif

  call EnableItalic()
  call EnableBold()
endfunction

function! PencilAfter()
  let g:lightline.colorscheme = 'pencil'

  " for Vim
  if &background == 'light'
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=231 guibg=NONE guifg=#e0e0e0
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=231 guibg=NONE guifg=#e0e0e0
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=231 guibg=NONE guifg=#e0e0e0
  else
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#424242
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#424242
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#424242
  endif

  call EnableItalic()
  call EnableBold()
endfunction

function! GithubAfter()
  let g:lightline.colorscheme = 'github'

  " 去掉文件尾部没有内容的区域的颜色设置.
  hi EndOfBuffer ctermbg=NONE guibg=NONE

  if &background == 'dark'
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#41484f
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#41484f
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#41484f
  else
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=251 guibg=NONE guifg=#c6c6c6
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=251 guibg=NONE guifg=#c6c6c6
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=251 guibg=NONE guifg=#c6c6c6
  endif

  call EnableItalic()
  call EnableBold()
endfunction

function! SrceryAfter()
  let g:lightline.colorscheme = 'srcery'

  hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=237 guibg=NONE guifg=#3A3A3A
  hi Whitespace cterm=NONE ctermbg=NONE ctermfg=237 guibg=NONE guifg=#3A3A3A
  hi Conceal cterm=NONE ctermbg=NONE ctermfg=237 guibg=NONE guifg=#3A3A3A

  hi htmlBold guibg=NONE

  call EnableItalic()
endfunction

function! SolarizedAfter()
  let g:lightline.colorscheme = 'solarized8'

  if &background == 'dark'
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#00384d
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#00384d
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#00384d
  else
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=251 guibg=NONE guifg=#c6c6c6
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=251 guibg=NONE guifg=#c6c6c6
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=251 guibg=NONE guifg=#c6c6c6
  endif

  call EnableItalic()
endfunction

function! SpringNightAfter()
  let g:lightline.colorscheme = 'spring_night'

  hi Whitespace cterm=NONE term=NONE guifg=#607080 ctermfg=60
  hi Conceal cterm=NONE term=NONE guifg=#607080 ctermfg=60

  call EnableItalic()
endfunction

function! GooglePrimaryAfter()
  let g:lightline.colorscheme = 'primary'

  if &background == 'dark'
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#5f6368
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#5f6368
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#5f6368
  else
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=251 guibg=NONE guifg=#c6c6c6
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=251 guibg=NONE guifg=#c6c6c6
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=251 guibg=NONE guifg=#c6c6c6
  endif

  call EnableItalic()
  call EnableBold()
endfunction

function! Base16FlatAfter()
  let g:lightline.colorscheme = 'base16_flat'

  hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#34495E
  hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#34495E
  hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#34495E

  call EnableItalic()
  call EnableBold()
endfunction

function! Base16CupertinoAfter()
  let g:lightline.colorscheme = 'base16_cupertino'

  hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#c0c0c0
  hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#c0c0c0
  hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#c0c0c0

  call EnableItalic()
  call EnableBold()
endfunction

function! Base16MateriaAfter()
  let g:lightline.colorscheme = 'base16_materia'

  hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#37474F
  hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#37474F
  hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#37474F

  call EnableItalic()
  call EnableBold()
endfunction

function! MonokaiAfter()
  let g:lightline.colorscheme = 'monokai'

  " 使非文本区域和文本区域的颜色方案保持一致.
  if (g:enable_bg_transparent == 0)
    hi NonText ctermfg=231 ctermbg=235 cterm=NONE guifg=#f8f8f2 guibg=#272822 gui=NONE
  endif

  " monokai 主题的 Pmenu 默认是透明背景的, 这里改成不透明.
  hi Pmenu ctermfg=NONE ctermbg=237 cterm=NONE guifg=NONE guibg=#3c3d37 gui=NONE

  hi SpecialKey ctermfg=NONE ctermbg=237 cterm=NONE guifg=#49483e guibg=NONE gui=NONE
  hi Whitespace ctermfg=NONE ctermbg=237 cterm=NONE guifg=#49483e guibg=NONE gui=NONE
  hi Conceal ctermfg=NONE ctermbg=237 cterm=NONE guifg=#49483e guibg=NONE gui=NONE

  call EnableItalic()
  call EnableBold()
endfunction

function! Base16AtelierDuneAfter()
  let g:lightline.colorscheme = 'base16_atelier_dune'

  if g:colors_name == 'base16-atelier-dune'
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#4C4939
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#4C4939
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#4C4939
  else
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=251 guibg=NONE guifg=#CCC8B3
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=251 guibg=NONE guifg=#CCC8B3
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=251 guibg=NONE guifg=#CCC8B3
  endif

  call EnableItalic()
  call EnableBold()
endfunction

function! Base16OceanicnextAfter()
  let g:lightline.colorscheme = 'base16_oceanicnext'

  hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#4F5B66
  hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#4F5B66
  hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#4F5B66

  call EnableItalic()
  call EnableBold()
endfunction

function! EmbarkAfter()
  let g:lightline.colorscheme = 'embark'

  hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#585273
  hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#585273
  hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#585273

  call EnableItalic()
endfunction

function! OffAfter()
  let g:lightline.colorscheme = 'off'

  if &background == 'dark'
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#545454
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#545454
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#545454
  else
    hi SpecialKey cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#c6c6c6
    hi Whitespace cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#c6c6c6
    hi Conceal cterm=NONE ctermbg=NONE ctermfg=238 guibg=NONE guifg=#c6c6c6
  endif

  call EnableItalic()
  hi Special cterm=italic gui=italic guifg=NONE ctermfg=NONE

  call EnableBold()
endfunction

" }}

" *********************************

function! SetColorscheme()
  " 启用或禁用 Vim 背景透明色特性.
  call ToggleVimTransparentBgFeature()

  " colorscheme 指令之前执行的主题优化方法.
  call GruvboxBefore()
  call DraculaBefore()
  call NordBefore()
  call MolokaiBefore()
  call PaperColorBefore()
  call JellybeansBefore()
  call PencilBefore()
  call GithubBefore()
  call SrceryBefore()
  call SolarizedBefore()

  " 设置 colorscheme.
  call Colorscheme()

  " colorscheme 指令之后执行的主题优化方法.
  if exists('g:colors_name')
    call BGTransparentAfter()

    if g:colors_name == 'rigel'
      call RigelAfter()
    elseif g:colors_name == 'dracula'
      call DraculaAfter()
    elseif g:colors_name == 'one'
      call OneAfter()
    elseif g:colors_name == 'molokai'
      call MolokaiAfter()
    elseif g:colors_name == 'monokai'
      call MonokaiAfter()
    elseif g:colors_name == 'gruvbox'
      call GruvboxAfter()
    elseif g:colors_name == 'iceberg'
      call IcebergAfter()
    elseif g:colors_name == 'jellybeans'
      call JellybeansAfter()
    elseif g:colors_name == 'nord'
      call NordAfter()
    elseif g:colors_name == 'tender'
      call TenderAfter()
    elseif g:colors_name == 'PaperColor'
      call PaperColorAfter()
    elseif g:colors_name == 'ayu'
      call AyuAfter()
    elseif g:colors_name == 'vadelma'
      call VadelmaAfter()
    elseif g:colors_name == 'pencil'
      call PencilAfter()
    elseif g:colors_name == 'github'
      call GithubAfter()
    elseif g:colors_name == 'srcery'
      call SrceryAfter()
    elseif g:colors_name == 'solarized8'
      call SolarizedAfter()
    elseif g:colors_name == 'spring-night'
      call SpringNightAfter()
    elseif g:colors_name == 'primary'
      call GooglePrimaryAfter()
    elseif g:colors_name == 'base16-default-dark'
      call Base16DefaultDarkAfter()
    elseif g:colors_name == 'base16-flat'
      call Base16FlatAfter()
    elseif g:colors_name == 'base16-cupertino'
      call Base16CupertinoAfter()
    elseif g:colors_name == 'base16-materia'
      call Base16MateriaAfter()
    elseif g:colors_name =~ 'onehalf'
      call OnehalfAfter()
    elseif g:colors_name =~ 'base16-atelier-dune'
      call Base16AtelierDuneAfter()
    elseif g:colors_name =~ 'base16-oceanicnext'
      call Base16OceanicnextAfter()
    elseif g:colors_name == 'embark'
      call EmbarkAfter()
    elseif g:colors_name == 'off'
      call OffAfter()
    endif
  endif

  " 设置提示列的颜色方案.
  call SignColumnHi()

  " 优化 ale 错误提示标识的颜色方案.
  call ALESignHi()

  " 为 coc-git 插件提供 git 增删改提示标识的高亮颜色方案.
  call GitSignHi()
endfunction

call SetColorscheme()

" *** Vim/Neovim 已打开的实例自动更新 colorscheme ***
" 通过命令行或快捷键变更 colorscheme 时, 使打开的 vim/neovim 实例自动更新 colorscheme.

let g:vim_colorscheme_toggle_tmpfile = '~/.vim/signal.tmp'

function! CheckUpdate(timer)
  if filereadable(expand(g:vim_colorscheme_toggle_tmpfile))
    call SetColorscheme()
    call LightlineReload()

    silent! execute '!rm -f ' . g:vim_colorscheme_toggle_tmpfile
  endif

  " 每 50ms 运行一次该函数.
  call timer_start(50, 'CheckUpdate')
endfunction

if !exists("g:CheckUpdateStarted")
  let g:CheckUpdateStarted=1
  " 1ms 后运行, 相当于立即运行.
  call timer_start(1, 'CheckUpdate')
endif

" ***************************************************

" ,b  normal 模式下, 在背景是 dark 和 light 之间切换.
nnoremap <silent> <leader>b :call ToggleBGColor()<CR>

" ,o  normal 模式下, 在背景透明和不透明之间切换.
" NOTE: terminal 需要设置透明度, Vim 才能看到切换效果.
nnoremap <silent> <leader>o :call ToggleBGTransparent()<CR>

" }}

" 代码自动补全  Code Completion {{

"""""""" Exafunction/codeium.vim
" A free AI Completion
" doc: https://github.com/Exafunction/codeium.vim

" Disable default keybindings
let g:codeium_disable_bindings = 1

" <C-]>  Manually trigger suggestion
imap <C-]> <Cmd>call codeium#Complete()<CR>
" <C-j>  Next suggestion
imap <C-j> <Plug>(codeium-next)
" <C-k>  Previous suggestion
imap <C-k> <Plug>(codeium-previous)
" <C-x>  Clear current suggestion
imap <C-x> <Plug>(codeium-dismiss)

" <C-y>  Insert suggestion
imap <script><silent><nowait><expr> <C-y> codeium#Accept()


"""""""" neoclide/coc.nvim
" CoC 的全称是: Conqure of Completion
" doc: https://github.com/neoclide/coc.nvim
"

" *** 基本命令 ***
"                  :CocInfo  补全服务启动失败原因查看.
"               :CocOpenLog  查看补全服务的日志.
"                :CocConfig  打开 ~/.vim/coc-settings.json.
"                            NOTE: 已映射快捷键 :C
"       :CocList extensions  查看安装了哪些扩展, 通过 ctrl k/j 上下滚动查看:
"                            * 表示激活的扩展;
"                            + 表示已经加载的扩展;
"                            - 表示禁用的扩展;
"                            ? 表示不正常的扩展.
"                            选中某一个扩展后, 按 tab 键将会提示相应的操作.
"                            NOTE: 已映射快捷键 space e
"      :CocInstall coc-json  安装 Json language server.
"    :CocUninstall coc-json  卸载 Json language server.
"                :CocUpdate  更新所有扩展.
"          :CocList sources  列出当前已经有哪些代码补全的数据源.
" ****************

" *** 补全菜单的符号说明 ***
"   [LS]  Language Server, 补全来自语言服务器.
"    [S]  Snippets, 补全来自 Snippets.
"   [US]  UltiSnips, 补全来自 UltiSnips.
"   [TN]  TabNine, 补全来自 TabNine.
"  [GOC]  Gocode, 补全来自 gocode.
"  [NEC]  Neco-vim, 补全来自 Shougo/neco-vim 插件.
"    [A]  Around, 补全来自当前文件(buffer).
"    [B]  Buffer, 补全来自其他已经打开的文件(buffer).
"    [F]  File, 补全来自文件名自动检测.
"      M  Module, 此条补全会导入一个模块.
"      m  method, 是一个方法名.
"      I  Interface, 是一个接口.
"      S  Struct, 是一个结构体.
"      f  func, 是一个函数.
"      v  variable, 是一个变量.
"      C  custom, 是一个自定义的类型.
" **************************

if &rtp =~ '/coc.nvim,'
  " 设置隐藏模式, 未保存的 buffer (文件)可以被切换走或者关闭;
  " 如果不设置这个, TextEdit 可能失败.
  set hidden

  " 底部命令模式的显示高度, 默认值 1.
  " 设置为 2 是为了给提示信息更多的展示空间, 防止信息截断.
  set cmdheight=2

  " 不要将信息传递给 ins-completion-menu.
  set shortmess+=c

  " *** coc.nvim 扩展安装 ***
  " 将需要安装的 coc.nvim 扩展(语言服务器等) 放到数组中,
  " 打开 vim 时, coc.nvim 会自动对扩展进行自动安装.
  " doc: https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
  " 部分扩展说明:
  "   coc-jedi: Python3.6.1+
  "   coc-css: Css/Less/Sass
  "   coc-vetur: 需要在 vue 项目根路径下运行: npm i eslint eslint-plugin-vue -D
  "   coc-snippets: 需要安装 vim 插件: Plug 'honza/vim-snippets'
  "   coc-ultisnips: 需要安装 vim 插件: Plug 'SirVer/ultisnips'
  "   coc-gocode: 为 Go 提供代码片段补全的数据库, 需安装gocode: go install github.com/nsf/gocode@latest
  "   coc-emoji: Emoji words, 默认只对 markdown 类型文件开启, 通过 : 触发.
  "   coc-xml: 系统中需要安装 java: brew install java
  "   coc-tabnine: 基于 AI 的自动补全，可以辅助更快地撰写代码.
  let g:coc_global_extensions = [
    \ 'coc-json',
    \ 'coc-git',
    \ 'coc-go',
    \ 'coc-gocode',
    \ 'coc-rls',
    \ 'coc-rust-analyzer',
    \ 'coc-clangd',
    \ 'coc-jedi',
    \ 'coc-java',
    \ 'coc-sh',
    \ 'coc-perl',
    \ 'coc-tsserver',
    \ 'coc-css',
    \ 'coc-cssmodules',
    \ 'coc-emmet',
    \ 'coc-html',
    \ 'coc-vetur',
    \ 'coc-sql',
    \ 'coc-toml',
    \ 'coc-yaml',
    \ 'coc-xml',
    \ 'coc-vimlsp',
    \ 'coc-snippets',
    \ 'coc-ultisnips',
    \ 'coc-emoji',
    \ 'coc-swagger',
    \ 'coc-translator',
    \ 'coc-tabnine',
    \ ]
  " *************************

  " *** ~/.vim/coc-settings.json ***
  "   该配置文件可对 coc.nvim 以及安装的各种扩展进行个性配置,
  "   如果已经安装了 coc-json 扩展, 则该配置文件将支持自动补全和合法性检查,
  "   方便我们进行配置.

  " :C  打开 ~/.vim/coc-settings.json 配置文件.
  function! SetupCommandAbbrs(from, to)
    exec 'cnoreabbrev <expr> '.a:from
      \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
      \ .'? ("'.a:to.'") : ("'.a:from.'"))'
  endfunction
  call SetupCommandAbbrs('C', 'CocConfig')
  " ********************************

  " *** coc-tabnine ***
  " doc: https://github.com/neoclide/coc-tabnine
  "
  " 1) 打开 TabNine 的配置文件
  "    :CocCommand tabnine.openConfig
  "    NOTE: 如果如上命令无法打开 TabNine 的配置文件, 说明 TabNine 没有正确安装.
  "    需要先删除 ~/.config/coc/extensions/coc-tabnine-data,
  "    然后重新安装 coc-tabnine, :CocInstall coc-tabnine
  " 2) 为了使 coc.nvim 更好的配合 TabNine 工作, 将如下条目加入到 TabNine 的配置文件
  "    "ignore_all_lsp": true
  " 3) 成功安装配置后, 在代码补全的时候, 补全提示列表中会存在标识为 [TN] 的代码源.
  " *******************

  " *** coc-translator ***
  " doc: https://github.com/voldikss/coc-translator
  " NOTE: 有可能被google翻译禁止使用其接口导致翻译失败报错.

  " normal 和 visual 模式下, 将光标下的单词以弹出漂浮窗口的方式显示翻译结果.
  nmap ts <Plug>(coc-translator-p)
  vmap ts <Plug>(coc-translator-pv)
  " 在状态栏下面显示翻译的结果.
  nmap tse <Plug>(coc-translator-e)
  vmap tse <Plug>(coc-translator-ev)
  " 将翻译结果替换掉光标下的单词.
  nmap tsr <Plug>(coc-translator-r)
  vmap tsr <Plug>(coc-translator-rv)
  " **********************

  " *** coc-css ***
  autocmd FileType scss setl iskeyword+=@-@
  " ***************

  " *** coc-git ***
  " navigate chunks of current buffer
  nmap [g <Plug>(coc-git-prevchunk)
  nmap ]g <Plug>(coc-git-nextchunk)
  " navigate conflicts of current buffer
  nmap [c <Plug>(coc-git-prevconflict)
  nmap ]c <Plug>(coc-git-nextconflict)
  " show chunk diff at current position
  nmap <leader>gd <Plug>(coc-git-chunkinfo)
  " show commit contains current position
  nmap <leader>gc <Plug>(coc-git-commit)
  " ***************

  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: 1) There's always complete item selected by default, you may want to enable
  " no select by `"suggest.noselect": true` in your configuration file.
  " 2) Use command ':verbose imap <tab>' to make sure <tab> is not mapped by
  " other plugin before putting this into your config.
  inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1) :
    \ CheckBackspace() ? "\<Tab>" :
    \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

  " Make <CR> to accept selected completion item or notify coc.nvim to format
  " <C-g>u breaks current undo, please make your own choice.
  " NOTE: Use command ':verbose imap <cr>' to make sure <cr> is not mapped by other plugin
  " before putting this into your config.
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " SirVer/ultisnips 插件触发补全的默认配置是 tab 键, 会和 coc 的冲突, 需要修改掉.
  " 实际上并不会用到这里设置的快捷键.
  let g:UltiSnipsExpandTrigger="<leader>,,,f"

  " gd/gl  新建标签页的方式跳转到定义处.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gl <Plug>(coc-definition)
  " gy  跳转到类型定义处.
  nmap <silent> gy <Plug>(coc-type-definition)
  " gi  跳转到实现处.
  " NOTE: 对于Go语言特别有用, 可以直接跳转到方法的实现处, 而不是方法所在接口的定义处.
  nmap <silent> gi <Plug>(coc-implementation)
  " gr  在 location list 中列出相关条目, 如果相关的只有1条, 则直接跳转过去.
  nmap <silent> gr <Plug>(coc-references)

  " ,rn  级联的对光标所在 symbol 进行重命名.
  nmap <leader>rn <Plug>(coc-rename)

  " K  在悬浮窗口中查看文档.
  nnoremap <silent> K :call <SID>show_documentation()<CR>
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    " 使支持 tmux-plugins/vim-tmux 插件.
    elseif (index(['tmux'], &filetype) >= 0)
      call tmux#man()
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

  " 突出显示光标所在 symbol 及其引用.
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " 使用 <C-f> 和 <C-b> 在悬浮窗口向下和向上滚动, 每次滚动行数为 lines_count,
  " 比如在查看较长的文档时出现了滚动条的场景下使用.
  let lines_count=5
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ?
    \ coc#float#scroll(1, lines_count) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ?
    \ coc#float#scroll(0, lines_count) : "\<C-b>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ?
    \ coc#float#scroll(1, lines_count) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ?
    \ coc#float#scroll(0, lines_count) : "\<C-b>"
  " insert 模式下, 代码补全提示的选项列表中,
  " 通过 tab 选择一项所弹出来的详细说明窗口中如果出现滚动条,
  " 则可以使用此快捷键进行内容滚动, 否则分别表示向右或向左移动一个字符.
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ?
    \ "\<c-r>=coc#float#scroll(1, lines_count)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ?
    \ "\<c-r>=coc#float#scroll(0, lines_count)\<cr>" : "\<Left>"

  " *** CocList 相关命令快捷键映射 ***
  " NOTE: 按快捷键出现相关列表后, 使用 ctrl j/k/f/b 进行浏览, 使用 tab 进行管理.
  "
  " space e  列出所有扩展.
  nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
  " space c  列出所有命令.
  nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
  " space s  列出当前所在文件类型有哪些代码补全数据源.
  nnoremap <silent><nowait> <space>s  :<C-u>CocList sources<cr>
  " space p  重新列出上一次展示的 CocList.
  nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

endif

" }}

" 代码静态检查  Code Static Check {{

" ale 用于替代 syntastic 插件.
" NOTE: :ALEInfo  用于查看当前文件的语法检查配置情况,
" 内容尾部是对当前文件内容执行检查的日志, 可通过这些日志排查问题.
" doc: https://github.com/dense-analysis/ale

if &rtp =~ '/ale,'
  " 定制显示在行左侧的错误提示符和警告提示符.
  " 默认值: '>>'
  let g:ale_sign_error = '>>'
  " 默认值: '--'
  let g:ale_sign_warning = '--'

  " 左侧的错误/警告提示列是否一直保持打开, 默认值: 0
  let g:ale_sign_column_always = 0

  " 用于错误或警告提示的字符串.
  " 默认值: 'Error'
  let g:ale_echo_msg_error_str = 'Error'
  " 默认值: 'Warning'
  let g:ale_echo_msg_warning_str = 'Warning'

  " 设置提示信息的输出格式, 默认值: '%code: %%s'
  let g:ale_echo_msg_format = '[%linter%] %code: %%s [%severity%]'

  " 2 - Show problems for all lines. Default
  " 1 - Show problems for the current line.
  " 0 - Do not show problems with virtual-text.
  let g:ale_virtualtext_cursor = 1
  let g:ale_virtualtext_prefix = '%comment% %type%: '

  " 是否将 ale linter 发现的错误或警告的具体位置列表信息添加到 location list 中.
  " 我们这里禁用, 以防止使用 gr 时, 破坏 gr 使用的 location list.
  " 默认值: 1
  let g:ale_set_loclist = 0

  " 如果 location list 不为空, 是否打开一个独立的窗口显示其信息, 默认值: 0
  let g:ale_open_list = 0
  " 错误信息窗口的高度, 在 g:ale_open_list 设置为 1 时才有效果, 默认值: 10
  let g:ale_list_window_size = 5

  " 错误或警告信息全部修复后, 是否保留错误信息窗口, 1 表示保留, 默认值: 0
  let g:ale_keep_list_window_open = 0

  " 退出文件时, 如果仅剩错误信息窗口, 则其也一同退出(loclist).
  augroup CloseLoclistWindowGroup
    autocmd!
    autocmd QuitPre * if empty(&buftype) | lclose | endif
  augroup END

  " 新打开文件时是否自动 lint, 默认值: 1
  let g:ale_lint_on_enter = 1

  " 保存文件时是否进行 lint, 默认值: 1
  let g:ale_lint_on_save = 1

  " 保存文件时是否进行 fix,  默认值: 0
  let g:ale_fix_on_save = 1

  " , k/j 在错误提示之间跳转.
  nmap <silent> <leader>k <Plug>(ale_previous_wrap)
  nmap <silent> <leader>j <Plug>(ale_next_wrap)

  " 针对不同语言的静态代码检查工具配置.
  " NOTE: 1) 其他没有在这里配置的语言将使用 ale 默认配置的 linter,
  "   可以使用 :ALEInfo 来查看当前文件使用了哪些默认的 linter.
  "
  "   2) 注意需要在本地安装涉及到的命令行工具:
  "      brew install golangci-lint lua luarocks tidy-html5 shellcheck jq
  "      luarocks install luacheck
  "      npm install -g eslint standard eslint-plugin-vue vls \
  "          proselint alex write-good stylelint jsonlint
  "      pip3 install pylint flake8 yamllint
  "      go get github.com/golangci/golangci-lint/cmd/golangci-lint@v1.39.0
  "      go get -u github.com/mgechev/revive
  "      sudo gem install mdl
  "
  "      " for terraform
  "      brew install terraform
  "      brew install hashicorp/tap/terraform-ls
  "      brew install tflint
  "
  "      " for c
  "      brew install clang-format
  "
  "      " for css
  "      npm install --save-dev stylelint stylelint-config-standard stylelint-config-standard-scss
  "      " for markdown: https://github.com/igorshubovych/markdownlint-cli
  "      " NOTE: 安装完成后的二进制文件是markdownlint
  "      brew install markdownlint-cli
  "
  "   3) eslint 配置文件, 项目根目录下的 .eslintrc.json, 需要通过如下命令生成,
  "      我们这里使用 standard 风格: eslint --init
  "      或 vue create project-demo(需要选择手动配置, 选择 standard 风格),
  "      将配置生成到 package.json 的 eslintConfig 字段.
  "
  "   4) prettier 配置文件, 项目根目录下的 .prettierrc.json:
  "      {
  "        "singleQuote": true,
  "        "semi": false
  "      }
  "
  "   5) 对于 Python 项目, 如果使用虚拟环境, 需要在虚拟环境下安装相关 linter 工具,
  "      拿 Python 的依赖管理工具 poetry 举例:
  "      poetry init
  "      poetry shell
  "      poetry add pylint flake8 autoimport black isort -D -vvv
  "      如果要使用 neovim, 还需要 poetry add neovim -D -vvv
  "
  "   6) css 工具 stylint 配置:
  "      stylelint 配置文件, 项目根目录下的 .stylelintrc.json:
  "      {
  "        "extends": "stylelint-config-standard-scss"
  "        "rules": {
  "          "color-function-notation": "legacy",
  "          "selector-class-pattern": "^[a-zA-Z][a-zA-Z0-9-_]*$"
  "        }
  "      }
  "      配置规则参考: https://github.com/stylelint/stylelint/blob/main/docs/user-guide/rules/list.md
  let g:ale_linters = {
    \  'go': ['golangci-lint', 'gopls'],
    \  'c': ['cc', 'clangd'],
    \  'rust': ['analyzer', 'cargo', 'rls', 'rustc'],
    \  'python': ['pylint', 'flake8'],
    \  'lua': ['luac', 'luacheck'],
    \  'sh': ['shellcheck', 'language_server'],
    \  'zsh': ['shellcheck', 'language_server'],
    \  'javascript': ['eslint'],
    \  'vue': ['eslint', 'vls'],
    \  'html': ['tidy', 'stylelint', 'alex', 'writegood', 'proselint'],
    \  'css': ['stylelint'],
    \  'scss': ['stylelint'],
    \  'sass': ['stylelint'],
    \  'less': ['stylelint'],
    \  'yaml': ['yamllint'],
    \  'json': ['jq', 'jsonlint'],
    \  'jsonc': ['jq', 'jsonlint'],
    \  'markdown': ['markdownlint'],
    \  'terraform': ['terraform', 'terraform_ls', 'tflint'],
    \ }

  " golangci-lint 配置:
  " 指定可执行文件的具体名称.
  let g:ale_go_golangci_lint_executable = 'golangci-lint'
  " golanci-lint run 命令不加额外参数, 解决默认加的 --enable-all 参数导致的错误.
  let g:ale_go_golangci_lint_options = ''
  " golangci-lint run 命令以包为单位进行检查,
  " 解决默认以文件方式检查时的 typecheck 错误误报的问题.
  let g:ale_go_golangci_lint_package = 1

  " Put imports beginning with this string after 3rd-party packages;
  " comma-separated list
  " 执行goimports格式化时, 增加 -local 参数, 将指定前缀的包自动分组到第三方包后.
  " NOTE: 强烈建议在~/.vimrc.local中添加此条指令覆盖此配置, 而不是直接更改本配置文件.
  let g:ale_go_goimports_options = '-local github.com/windvalley'

  " flake8 配置:
  " 指定允许的 Python 代码每行最大字符数, 默认值 79.
  let g:ale_python_flake8_options = '--max-line-length 120'

  " yamllint 配置:
  " doc: https://yamllint.readthedocs.io/en/stable/configuration.html
  " 指定可执行文件的具体名称.
  let g:ale_yaml_yamllint_executable = 'yamllint'
  " 配置参数.
  let g:ale_yaml_yamllint_options = '-d "{
    \ extends: relaxed,
    \ rules: {
    \   line-length: {max: 200},
    \ },
    \ }"'

  " markdownlint 配置:
  " 指定可执行文件的具体名称.
  let g:ale_markdown_markdownlint_executable = 'markdownlint'
  " 增加配置文件.
  let g:ale_markdown_markdownlint_options = '-c ~/.markdownlint.yaml'

  "  scss 使用系统全局的 stylelint 命令.
  let g:ale_scss_stylelint_use_global = 1

  " 使用 shfmt 进行代码格式化时, 代码缩进使用4个空格替代默认的tab.
  let g:ale_sh_shfmt_options = '-i 4'

  " 针对不同语言的自动修复功能.
  "    需要安装相关的命令行工具:
  "       npm install -g prettier importjs lua-fmt
  "       pip3 install black isort
  "       go install mvdan.cc/sh/v3/cmd/shfmt@latest
  "       brew install pandoc
  "
  " NOTE: g:ale_fixers注意事项:
  "   1) 不要使用 python 的 autoimport 工具, 重新排版的 import 可能发生错误;
  "      用于 python 的 isort, 可选择性使用, 我这里也不启用,
  "      直接用 black 的 import 排版能力即可.
  "   2) lua 的 luafmt 可进行自动格式化, 由于其格式化效果不符合我的审美要求,
  "      我这里暂不启用.
  "   3) prettier 等工具自身就有 trim_whitespace 和 remove_trailing_lines 的能力,
  "      所以不用重复添加.
  let g:ale_fixers = {
    \  'go': ['gofmt', 'goimports', 'gopls'],
    \  'c': ['clang-format'],
    \  'rust': ['rustfmt'],
    \  'python': ['black', 'add_blank_lines_for_python_control_statements'],
    \  'lua': ['luafmt'],
    \  'sh': ['shfmt'],
    \  'javascript': ['eslint', 'importjs'],
    \  'vue': ['eslint'],
    \  'html': ['prettier'],
    \  'css': ['stylelint'],
    \  'scss': ['stylelint'],
    \  'sass': ['stylelint'],
    \  'less': ['stylelint'],
    \  'json': ['jq'],
    \  'jsonc': ['jq'],
    \  'yaml': ['prettier'],
    \  'markdown': ['prettier'],
    \  'vim': ['trim_whitespace', 'remove_trailing_lines'],
    \  'zsh': ['trim_whitespace', 'remove_trailing_lines'],
    \  'tmux': ['trim_whitespace', 'remove_trailing_lines'],
    \  'terraform': ['terraform', 'trim_whitespace', 'remove_trailing_lines'],
    \ }
endif

" }}

" 代码调试  Code Debug {{

"""""" puremourning/vimspector
" doc: https://github.com/puremourning/vimspector

if &rtp =~ '/vimspector,'
  let g:vimspector_enable_mappings = 'HUMAN'

  " 启动 debug 模式, 或运行到下一个断点.
  nmap <leader>dc <Plug>VimspectorContinue

  " 停止运行 debug 模式.
  nmap <leader>ds <Plug>VimspectorStop

  " 重新运行 debug 模式.
  nmap <leader>dr <Plug>VimspectorRestart

  " 设置行断点.
  nmap <leader>db <Plug>VimspectorToggleBreakpoint

  " 运行到下一行代码, 每按一次运行一行代码.
  nmap <leader>dl <Plug>VimspectorStepOver

  " step in 进入 breakpoint 所在行调用的函数内部.
  nmap <leader>di <Plug>VimspectorStepInto

  " step out 从进入的函数中返回.
  nmap <leader>do <Plug>VimspectorStepOut

  " 查看光标所在变量的值, 注意在 debug 模式下必须运行过了这一行才可以.
  nmap <Leader>dv <Plug>VimspectorBalloonEval
  xmap <Leader>dv <Plug>VimspectorBalloonEval

  " ,dj  选择模版文件, 在项目的根目录创建必须的 .vimspector.json 文件.
  noremap <silent><leader>dj :tabe .vimspector.json<CR>:LoadVimSpectorJsonTemplate<CR>

  function! s:read_template_into_buffer(template)
    execute '0r ~/.dotfiles/vim/vimspector/'.a:template
  endfunction

  command! -bang -nargs=* LoadVimSpectorJsonTemplate call fzf#run({
    \ 'source': 'ls -1 ~/.dotfiles/vim/vimspector',
    \ 'down': 10,
    \ 'sink': function('<sid>read_template_into_buffer')
    \ })

  " 断点图标.
  sign define vimspectorBP            text=🌕  texthl=NONE
  " 条件断点图标.
  sign define vimspectorBPCond        text=🔶  texthl=NONE
  " 失效的断点图标.
  sign define vimspectorBPDisabled    text=🌑  texthl=NONE
  " 当前调试到的非断点所在行图标.
  sign define vimspectorPC            text=💎  texthl=NONE       linehl=CursorLine
  " 当前调试到的断点所在行图标.
  sign define vimspectorPCBP          text=●▶  texthl=GitAddSign linehl=CursorLine
  " vimspector.StackTrace 窗口里显示的当前线程图标.
  sign define vimspectorCurrentThread text=🍎  texthl=NONE       linehl=CursorLine
  " vimspector.StackTrace 窗口里显示的当前线程的某段任务代码的所在图标.
  sign define vimspectorCurrentFrame  text=🍒  texthl=NONE       linehl=CursorLine

  " 解决其他插件的 sign 覆盖掉 vimspector sign 的问题.
  let g:vimspector_sign_priority = {
    \ 'vimspectorBP':            199,
    \ 'vimspectorBPCond':        199,
    \ 'vimspectorBPDisabled':    199,
    \ 'vimspectorPC':            200,
    \ 'vimspectorPCBP':          200,
    \ 'vimspectorCurrentThread': 200,
    \ 'vimspectorCurrentFrame':  200,
    \ }
endif

" }}

" 编程语言  Programming Languages {{

"""""""" Go {{

" 显示缩进线.
autocmd FileType go set list lcs=tab:\¦\ " 注意结尾有一个空格.

"""""" buoto/gotests-vim
" doc: https://github.com/buoto/gotests-vim
" :GoTests to generate a test for the function at the current line or functions selected in visual mode.
" :GoTestsAll to generate tests for all functions in the current buffer.

" normal 或 visual 模式下按 tt 生成光标所在函数或选择的函数的单元测试模版代码.
noremap tt :GoTests<CR>
" normal 或 visual 模式下按 gtt 生成当前 Go 文件的所有函数的单元测试模版代码.
noremap gtt :GoTestsAll<CR>

"""""" fatih/vim-go
" doc: https://github.com/fatih/vim-go

" *** 代码自动格式化 ***
" 使用 ale 插件来实现, 故禁用 vim-go 的相关功能.

" 默认值: 1
let g:go_fmt_autosave = 0

" 默认值: 1
let g:go_imports_autosave = 0

" *** 代码高效阅读 ***

" 使用 K 触发 :GoDoc 文档, 覆盖默认的 man, 默认值: 1, 表示启用;
" 此处禁用, 这里使用 coc.nvim 的 K 映射.
let g:go_doc_keywordprg_enabled = 0

" gr  在 location list 中列出哪些地方引用了光标所在的对象.
" NOTE: coc-go 的 gr 表现的更好, 故注释掉不使用此配置.
"au FileType go nmap gr :GoReferrers<CR>

" ,cl  在 location list 中列出哪些地方调用了光标所在的函数.
au FileType go nmap <leader>cl :GoCallers<CR>
" ,s  查看光标所在的类型实现了哪些接口, 注意光标只能在类型或类型的方法上.
au FileType go nmap <leader>s <Plug>(go-implements)

" NOTE: Go 跳转到光标所在函数定义处的 4 种方式均由 vim-go 插件提供.
"   如果光标所在函数定义处就是在当前页面, 则直接在当前页内跳转, 并不打开新页面;
"   如果在当前页面内跳转, 推荐使用 ctrl o/i 来回跳转切换, 以提高效率.
"
" gl  新开一个标签页的方式跳转到函数定义处, coc.nvim 提供的能力,
"     这里我们不使用 vim-go 提供的 go-def-tab,
"     因为 go-def-tab 经常会错误的以上下分屏的方式跳转到定义处.
"
" gd  以覆盖当前页面的方式跳转到函数定义处.
au FileType go nmap <silent> gd <Plug>(go-def)
" gs  上下分屏跳转到函数定义处.
au FileType go nmap <silent> gs <Plug>(go-def-split)
" gv  左右分屏跳转到函数定义处.
au FileType go nmap <silent> gv <Plug>(go-def-vertical)

" 对于跳转到对象定义处的功能, 重用已经打开的buffer. 默认值: 0
let g:go_def_reuse_buffer = 0

" *** 代码自动生成 ***

" ,im  自动为光标下的类型生成指定接口的实现方法.
au FileType go nmap <leader>im :GoImpl<CR>
" ,ki  自动把光标所在的结构体字面量(仅有value没有key的情况)补充上字段.
au FileType go nmap <leader>ki :GoKeyify<CR>
" ,fs  自动把光标所在的结构体字面量, 以字段零值方式补上尚未填写的字段.
au FileType go nmap <leader>fs :GoFillStruct<CR>
" ,ie  自动生成 if err != nil 代码段.
au FileType go nmap <leader>ie :GoIfErr<CR>
" ,at  为光标所在的结构体定义自动生成字段对应的tags.
au FileType go nmap <leader>at :GoAddTags<CR>

" 使用 :GoAddTags 时, 是否忽略未导出的结构体字段(即小写字段), 1 表示忽略. 默认值: 0
let g:go_addtags_skip_unexported = 1

" ,rn  级联的重命名光标下的标识符, 重命名后, 项目内的所有与其相关的地方全部会更新;
"      由于 coc.nvim 的 ,rn 表现的更好, 注释此配置.
"au FileType go nmap <leader>rn :GoRename<CR>

" 新创建一个 .go 文件时, 是否自动使用模版内容填充, 默认值: 1
let g:go_template_autocreate = 1
" 是否仅自动生成 package pkgname 一行代码, 默认值: 0
" NOTE: 将覆盖掉 let g:go_template_autocreate = 1 的作用.
let g:go_template_use_pkg = 1

" *** 运行当前 Go 文件 ***

" ,gr  go run 当前的 go 文件.
au FileType go nmap <leader>gr <Plug>(go-run)
" ,gb  go build 当前的 go 文件, 不产生二进制文件, 只是检查是否可以成功 build.
au FileType go nmap <leader>gb <Plug>(go-build)
" ,gt  go test 当前的 go 文件.
au FileType go nmap <leader>gt <Plug>(go-test)

" *** 代码语法高亮 ***

" 以下指令默认值都是 0.
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1

" 以下指令默认值都是1.
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_diagnostic_errors = 1
let g:go_highlight_diagnostic_warnings = 1

" *** 其他 ***

" 将 ctrl t 键绑定取消.
let g:go_def_mapping_enabled = 0

" }}

"""""""" Rust {{

"""""" mhinz/vim-crates
if has('nvim')
  autocmd BufRead Cargo.toml call crates#toggle()
endif

" }}

"""""""" Python {{

" requirements 文本文件内容也高亮显示.
autocmd BufNewFile,BufRead requirements*.txt set ft=python

" 新建 .py 结尾的文件时, 自动输入一些内容
func SetTitleForPython()
  call setline(1, "\#!/usr/bin/env python3")
  call setline(2, "\"\"\"")
  call setline(3, "Author: windvalley")  " 改成你自己的名字
  call setline(4, "Created Time: ".strftime("%Y-%m-%d %H:%M:%S"))
  call setline(5, "\"\"\"")
  normal G
  normal o
  normal o
  " 为新创建的 .py 文件自动赋予可执行权限
  au BufWritePost *.py silent !chmod a+x <afile>
endfunc
autocmd bufnewfile *.py call SetTitleForPython()

" 如果一个 .py 文件开头第一行不是以 #! 开头, 就去除掉文件的可执行权限.
function! NoShabang(line1, current_file)
  if a:line1 !~ '^#!'
    let chmod_command = "silent !chmod ugo-x " . a:current_file
    execute chmod_command
  endif
endfunction
autocmd BufWritePost *.py call NoShabang(getline(1), expand("%:p"))

" }}

"""""""" OpenResty/Lua {{

func SetTitleForLua()
  " 自动获取文件名称, 不包含文件扩展名.
  let filename = expand('%:r')
  let lua_module_name = join(["_M.name = \"", filename, "\""], "")

  call setline(1, "local ngx = require \"ngx\"")
  call setline(2, "")
  call setline(3, "")
  call setline(4, "local _M = {}")
  call setline(5, "")
  call setline(6, "_M._VERSION = 0.1")
  call setline(7, lua_module_name)
  call setline(8, "")
  normal G
  normal o
  normal o
endfunc
autocmd bufnewfile *.lua call SetTitleForLua()

" }}

"""""""" Javascript/vue/html/css {{

" css
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" 将 json 类型文件自动转换为 jsonc 类型, 这样就可以使用 // 和 /* */ 来注释了.
" NOTE: jsconfig.json 文件除外, 该文件不需要转换就是 jsonc 类型, 强制转化会报错.
autocmd BufNewFile,BufRead [^jsconfig]*.json set ft=jsonc

"""""" posva/vim-vue 插件
" 解决 vim-vue 插件导致的 Vim 速度变慢的问题.
let g:vue_pre_processors = []

"""""" 'mattn/emmet-vim'
" doc: https://raw.githubusercontent.com/mattn/emmet-vim/master/TUTORIAL
" 使用方法:
" 1. 打开 *.html 文件, 输入`html:5`, 然后`ctrl y ,`, 即可自动生成html代码模版
" 2. 输入`div`, 然后`ctrl y ,`, 即可自动生成: <div></div>
" 3. 输入`#foo`, 然后`ctrl y ,`, 可自动生成: <div id="foo"></div>
" 4. 输入`div>p>a`, 然后`ctrl y ,`, 可自动生成: <div><p><a href=""></a></p></div>

" Enable just for html/css
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

" 默认值: <C-y>
let g:user_emmet_leader_key='<C-y>'

" }}

"""""""" Shell {{

func SetTitleForShell()
  let current_filename = expand('%:t')
  call setline(1, "\#!/usr/bin/env bash")
  call setline(2, "# " . current_filename)
  call setline(3, "#")
  " 改成你自己的名字
  "call setline(4, "# Author: windvalley")
  "call setline(5, "# Created Time: ".strftime("%Y-%m-%d %H:%M:%S"))
  call setline(4, "")
  normal G
  normal o
  normal o
  " 为新创建的 .sh 文件自动赋予可执行权限
  au BufWritePost *.sh silent !chmod a+x <afile>
endfunc
autocmd bufnewfile *.sh call SetTitleForShell()

" }}

"""""""" Markdown {{

" 缩进大小改为 2 个空格, insert 模式下将 tab 扩展为 2 个空格.
au FileType markdown setlocal expandtab ts=2 sw=2 sts=2

""""""" dhruvasagar/vim-table-mode
" doc: https://github.com/dhruvasagar/vim-table-mode

" normal 模式下, 默认以 ,tm 来开启或关闭 table mode.
noremap <leader>tm :TableModeToggle<CR>

" 在 insert 模式下, 输入 ||| 后按 ESC 来开启 table mode,
" 输入 __ 后按 ESC 关闭 table mode.
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?')
    \ . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
  \ <SID>isAtStartOfLine('\|\|') ?
  \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'

inoreabbrev <expr> __
  \ <SID>isAtStartOfLine('__') ?
  \ '<c-o>:silent! TableModeDisable<cr>' : '__'

""""""" instant-markdown/vim-instant-markdown
" doc: https://github.com/instant-markdown/vim-instant-markdown

" ,p  打开浏览器预览.
nmap <silent><leader>p :InstantMarkdownPreview<CR>

" ,,p  关闭预览.
nmap <silent><leader><leader>p :InstantMarkdownStop<CR>

" 是否打开 markdown 类型文件时自动打开预览, 默认值: 1
let g:instant_markdown_autostart = 0

" 指定日志文件.
let g:instant_markdown_logfile = '/tmp/instant_markdown.log'

""""""" 自定义快速输入 markdown 语法标识符的快捷键
" from: https://github.com/theniceboy/nvim/blob/master/md-snippets.vim
" NOTE: 此部分定义的快捷键需要全部在 insert 模式下使用.

" ,b  生成粗体字标识符.
autocmd Filetype markdown inoremap <buffer> <leader>b **** <++><Esc>F*hi
" ,i  生成斜体字标识符.
autocmd Filetype markdown inoremap <buffer> <leader>i ** <++><Esc>F*i
" ,s  生成删除线标识符.
autocmd Filetype markdown inoremap <buffer> <leader>s ~~~~ <++><Esc>F~hi

" ,d  生成行内代码标识符.
autocmd Filetype markdown inoremap <buffer> <leader>d `` <++><Esc>F`i
" ,c  生成代码段标识符.
autocmd Filetype markdown inoremap <buffer> <leader>c
  \ ```<Enter><++><Enter>```<Enter><Enter><++><Esc>4kA

" ,m  生成代办事项标识符.
autocmd Filetype markdown inoremap <buffer> <leader>m - [ ] <Esc>a
" ,p  生成图片链接标识符.
autocmd Filetype markdown inoremap <buffer> <leader>p ![](<++>) <++><Esc>F[a
" ,a  生成超链接标识符.
autocmd Filetype markdown inoremap <buffer> <leader>a [](<++>) <++><Esc>F[a

" ,1/2/3/4/5/6  生成一级到六级标题.
autocmd Filetype markdown inoremap <buffer> <leader>1 #<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap <buffer> <leader>2 ##<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap <buffer> <leader>3 ###<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap <buffer> <leader>4 ####<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap <buffer> <leader>5 #####<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap <buffer> <leader>6 ######<Space><Enter><++><Esc>kA

" ,l  生成水平线.
autocmd Filetype markdown inoremap <buffer> <leader>l ---<Enter><Enter>

" ,f  以上几乎每一个快捷键都会生成一个占位符(<++>), 按 ,f 光标会跳转到占位符, 并同时删除占位符.
autocmd Filetype markdown inoremap <buffer> <leader>f <Esc>/<++><CR>:nohlsearch<CR>"_c4l
" ,w  相比于 ,f 还会增加一个换行动作.
autocmd Filetype markdown inoremap <buffer> <leader>w <Esc>/<++><CR>:nohlsearch<CR>"_c5l<CR>

" }}

"""""""" Vim/Neovim {{

" 缩进大小改为 2 个空格, insert 模式下将 tab 扩展为 2 个空格,
" 此时, 如果想打印 tab 本身的话, 需要按 ctrl v tab
au FileType vim setlocal expandtab ts=2 sw=2 sts=2

" }}

"""""""" Yaml {{

au FileType yaml setlocal expandtab ts=2 sw=2 sts=2

" }}

" }}

" 光标移动  Cursor Movement {{

"""""" easymotion/vim-easymotion
" doc: https://github.com/easymotion/vim-easymotion

if &rtp =~ '/vim-easymotion,'
  " 标记所有窗口的单词.
  nmap <leader>w <Plug>(easymotion-overwin-w)
  " 仅标记当前窗口的单词.
  "map  <leader>w <Plug>(easymotion-bd-w)

  " 标记所有窗口的所有行首字符.
  nmap <leader>L <Plug>(easymotion-overwin-line)
  " 标记当前窗口的所有行首字符.
  "map <leader>L <Plug>(easymotion-bd-jk)

  " 标记当前行光标右侧的字符.
  map <leader>l <Plug>(easymotion-lineforward)

  " 标记当前行光标左侧的字符.
  map <leader>h <Plug>(easymotion-linebackward)

  " 输入 1 个目标字符即可高亮定位, 支持多窗口同时定位.
  nmap s <Plug>(easymotion-overwin-f)
  " 需要输入 2 个目标字符才可高亮定位, 支持多窗口同时定位.
  "nmap s <Plug>(easymotion-overwin-f2)

  " 是否启用默认的快捷键映射, 默认值: 1, 表示启用.
  let g:EasyMotion_do_mapping = 1

  " 搜索字母的时候是否忽略大小写和 Vim 的 smartcase 表现一致.
  let g:EasyMotion_smartcase = 1

  " 搜索小写字母, 搜索结果大小写字母都包含, 但搜索大写字母时, 搜索结果仅包含大写字母.
  let g:EasyMotion_use_smartsign_us = 1
endif

" }}

" 文本编辑  Text Editing {{

"""""" matze/vim-move
" doc: https://github.com/matze/vim-move
"
" [n] meta k/j/h/l   normal 模式下将光标所在行向上/向下移动 n 行,
"                    或将光标所在字符向左/向右移动 n 个字符;
"                    visual 模式下将选择的内容向上/向下移动 n 行,
"                    或将选择的内容块向左/向右移动 n 个字符.

if &rtp =~ '/vim-move,'
  " 默认值为 M, 即 Meta 键, 也就是 macOS 的 Option 键, Windows 的 Alt 键.
  " 可选值:
  "   M: Meta(Alt/Option)
  "   C: Ctrl
  "   S: Shift
  let g:move_key_modifier = 'M'
endif

"""""" tpope/vim-commentary
" doc: https://github.com/tpope/vim-commentary

" 对于jsonc文件类型, 定制注释标识符为: //
autocmd FileType jsonc setlocal commentstring=//\ %s

" }}

" 文件浏览  File Navigation {{

"""""" preservim/nerdtree
" doc: https://github.com/preservim/nerdtree

if &rtp =~ '/nerdtree,'
  " ,t  normal 模式下显示或隐藏目录树的快捷键.
  nnoremap <leader>x :NERDTreeToggle<CR>

  " 目录树显示在左侧还是右侧.
  " 可选值: 'right', 'left', 默认值: 'left'
  let NERDTreeWinPos = 'left'

  " 设置目录树窗口宽度, 默认值: 31
  let NERDTreeWinSize=35

  " 不显示目录树上方的 'Bookmarks' 和 'Press ? for help' 文本,
  " 默认值为 0, 表示显示, 1 表示不显示.
  let NERDTreeMinimalUI=1

  " 按 m 键触发 menu 的时候, 是否使用精简版 menu, 类似这种:
  "   Menu: [ (a)dd ,m,d,r,o,q,c,l] (Use j/k/enter or shortcut):
  " 默认值: 0, 表示不使用.
  let NERDTreeMinimalMenu=0

  " 运行 Vim 时, 后面不接任何文件的情况, 自动打开目录树窗口.
  " NOTE: 会与 vim-startify 插件冲突, 注释掉, 暂时不使用.
  "autocmd StdinReadPre * let s:std_in=1
  "autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

  " 运行 Vim 的时候自动打开目录树. 如果 vim 后面接了文件, 则将光标自动移动到文件窗口.
  " NOTE: 如果使用 tmux, 不建议启用此条配置.
  "autocmd StdinReadPre * let s:std_in=1
  "autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

  " 如果文件都退出了, 只剩目录树窗口的情况下自动退出 Vim.
  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree')
    \ && b:NERDTree.isTabTree() | quit | endif

  " 每新打开一个标签页都显示当前已存在的目录树窗口.
  " NOTE: 1)官方提供的指令是: autocmd BufWinEnter * silent NERDTreeMirror,
  " 但经过实测, 会和以下2条指令产生冲突, 当 gd 或 gr 打开新的 buffer 时会报错:
  " 冲突的2条指令是:
  "   1) let g:ale_set_loclist = 1
  "   2) map gr :YcmCompleter GoToReferences<CR>
  " 修改为当前指令后, 可修复此问题.
  " 2) 如果使用 tmux, 不建议启用此条配置.
  "autocmd BufWinEnter *.* silent NERDTreeMirror

  " 当项目下新增或删除文件时, 目录树窗口中自动更新变化,
  " 省去了在目录树窗口中手动按 R 的动作了;
  " 注意, 需要光标移动到目录树窗口中或重新打开目录树窗口来触发更新动作.
  autocmd BufEnter NERD_tree_* | execute 'normal R'

  " 目录树中目录折叠与展开的样式, 默认值: '▸' 和 '▾';
  " 可供选择: '+' 与 '~', '<' 与 'v', 等等.
  let g:NERDTreeDirArrowExpandable = '▸'
  let g:NERDTreeDirArrowCollapsible = '▾'

  " 是否显示隐藏文件, 默认值: 0, 表示不显示.
  let NERDTreeShowHidden=1

  " 忽略哪些文件的显示, 开启这个将默认显示隐藏文件.
  let NERDTreeIgnore=['\.git$','\.pyc$','__pycache__','\.swp$']

  " 是否显示目录树的行号, 默认值: 0, 表示不显示.
  let NERDTreeShowLineNumbers=0
endif

"""""" 'francoiscabrol/ranger.vim'
" doc: https://github.com/francoiscabrol/ranger.vim
" NOTE: 需要在 ~/.zshrc 中加入 export LC_ALL="en_US.UTF-8", 否则 ranger 中将出现乱码.

if &rtp =~ '/ranger.vim,'
  " 禁用默认的 <leader>f 快捷键.
  let g:ranger_map_keys = 0

  " ,r  打开 ranger, 选择文件后按 l 或 enter 以新建标签页的方式打开文件,
  " 如果文件已经打开了, 则直接跳转到相关的标签页.
  map <leader>r :RangerCurrentFileExistingOrNewTab<CR>
endif

"""""" Yggdroot/LeaderF
" 需要在系统上提前安装 rg 命令: brew install rg
" doc: https://github.com/Yggdroot/LeaderF

if &rtp =~ '/LeaderF,'
  " 项目根目录的标志.
  let g:Lf_RootMarkers = ['.git']

  " 设置 LeaderF 工作目录为项目根目录, 如果不在项目中, 则为当前目录.
  let g:Lf_WorkingDirectoryMode = 'A'

  " 预览代码, 默认值: 0
  let g:Lf_PreviewCode = 1

  " 弹出独立的窗口来显示搜索文件.
  let g:Lf_WindowPosition = 'popup'

  " 弹出的窗口占终端屏幕的百分比, 0.8 即 80%.
  let g:Lf_PopupWidth = 0.8

  " 是否在弹出的窗口中预览搜索结果, 默认值: 0
  let g:Lf_PreviewInPopup = 1

  " 弹出的窗口的颜色模式, 默认值: 'default';
  " 可选值: gruvbox_default, gruvbox_material, one;
  " 可在 LeaderF/autoload/leaderf/colorscheme/popup 目录中增加新的颜色方案文件;
  " 经过测试 one 可以适配几乎所有颜色主题, 所以建议设置为 one.
  let g:Lf_PopupColorscheme = 'one'

  " 弹出的窗口的高度, 默认值: 0.4, 表示占屏幕的 40%.
  let g:Lf_PopupHeight = 0.6

  " normal 模式下 ,f  进入文件搜索的模糊搜索方式; 再 ctrl r  进入 正则匹配 方式.
  let g:Lf_ShortcutF = ",ff"

  " 搜索当前已经打开的所有文件的内容.
  noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>

  " 显示最近打开过的文件列表.
  noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>

  " 显示当前文件的 tag 信息.
  noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>

  " 显示当前文件去除空行之外的所有行.
  noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>

  " normal 模式下按 ,rg 进入 command-line 模式下,
  " 然后输入要搜索的文本(支持正则表达式), 回车即可显示此项目内包含此文本的文件列表;
  " 在弹出的结果窗口中, 按 gi 可以将光标移动到输入框, 可以继续输入内容缩小结果列表,
  " 然后按 tab 进入结果列表中, 按 j/k 上下选择, 选择一个文件后,
  " 按 t 将以新建标签页的方式打开选择的文件.
  noremap <leader>rg :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>

  " visual 模式下选择文本后, 按 rg 在整个项目内搜索选择的文本, 显示搜索结果.
  xnoremap rg :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR><CR>

  " ,rg 搜索内容关闭后, 想再次搜索上次搜索的内容, normal 模式下按 rc 即可.
  noremap <leader>rc :<C-U>Leaderf! rg --recall<CR>
endif

" }}

" Git相关  Git Related {{

"""""" Xuyuanp/nerdtree-git-plugin
if &rtp =~ '/nerdtree-git-plugin,'
  let g:NERDTreeGitStatusIndicatorMapCustom = {
    \  "Modified"  : "✹",
    \  "Staged"    : "✚",
    \  "Untracked" : "✭",
    \  "Renamed"   : "➜",
    \  "Unmerged"  : "═",
    \  "Deleted"   : "✖",
    \  "Dirty"     : "✗",
    \  "Clean"     : "✔︎",
    \  'Ignored'   : '☒',
    \  "Unknown"   : "?"
    \ }
endif

"""""" rhysd/git-messenger.vim
" doc: https://github.com/rhysd/git-messenger.vim

if &rtp =~ '/git-messenger,'
  " 弹出 popup window 时, 自动将光标移动到 popup window, 如果设置为 v:false,
  " 则需要通过 ctrl ww 快捷键将光标移动到 popup window.
  let g:git_messenger_always_into_popup = v:true

  " 自定义 commit 时间显示的格式.
  let g:git_messenger_date_format = "%Y %b %d %X"
endif

" }}

" 用户接口  User Interface {{

"""""" 'mhinz/vim-startify'
" doc: https://github.com/mhinz/vim-startify

if &rtp =~ '/vim-startify,'
  " Returns all modified files of the current git repo.
  " `2>/dev/null` makes the command fail quietly, so that when we are not
  " in a git repo, the list will be empty.
  function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
  endfunction

  " Same as above, but show untracked files, honouring .gitignore
  function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
  endfunction

  let g:startify_lists = [
    \ { 'type': 'files',     'header': ['   MRU']            },
    \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
    \ { 'type': 'sessions',  'header': ['   Sessions']       },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
    \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
    \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
    \ { 'type': 'commands',  'header': ['   Commands']       },
    \ ]

  " Create a custom header using figlet.
  "   MacOS: brew install figlet
  "let g:startify_custom_header =
    "\ startify#pad(split(system('figlet -w 100 VimHack/Dotfiles'), '\n'))
  let g:startify_custom_header = [
        \ '   __     ___           _   _            _        ______        _    __ _             ',
        \ '   \ \   / (_)_ __ ___ | | | | __ _  ___| | __   / /  _ \  ___ | |_ / _(_) | ___  ___ ',
        \ '    \ \ / /| | ''_ ` _ \| |_| |/ _` |/ __| |/ /  / /| | | |/ _ \| __| |_| | |/ _ \/ __|',
        \ '     \ V / | | | | | | |  _  | (_| | (__|   <  / / | |_| | (_) | |_|  _| | |  __/\__ \',
        \ '      \_/  |_|_| |_| |_|_| |_|\__,_|\___|_|\_\/_/  |____/ \___/ \__|_| |_|_|\___||___/',
        \ ]

  " Custom footer.
  let g:startify_custom_footer= 'startify#pad(startify#fortune#cowsay())'
endif

"""""" majutsushi/tagbar
if &rtp =~ '/tagbar,'
  " 显示或隐藏大纲视图的快捷键: `,e`
  nmap ,e :TagbarToggle<CR>

  " Tagbar 窗口是否显示在左侧, 默认值: 0, 表示显示在右测.
  let g:tagbar_left = 0

  " 设置 Tagbar 窗口宽度, 默认值: 40
  let g:tagbar_width = 35

  " 是否开启自动预览, 如果开启, 将光标移动到 Tagbar 窗口时, 会自动打开一个新窗口用于预览,
  " 随着光标在标签上移动, 预览窗口也会实时进行代码定位.
  " 默认值: 0, 表示不开启预览.
  let g:tagbar_autopreview = 1

  " 根据 tag 的名称排序, 默认值: 1.
  " 设置为 0 表示禁用排序, 即按标签本身在代码文件中的位置排序.
  let g:tagbar_sort = 0
endif

"""""" 'Yggdroot/indentLine'
" doc: https://github.com/Yggdroot/indentLine

if &rtp =~ '/indentLine,'
  " 此插件会自动设置 set conceallevel=2, 导致 markdown/text 隐藏部分语法的显示,
  " 比如 markdown 的 ** **, 通过在这里排除掉 markdown 等文件类型来解决这个问题.
  " NOTE: 如果 json 类型文件中无法显示双引号可能也是由此插件导致,
  " 把 json 和 jsonc 添加到下面列表中即可.
  let g:indentLine_fileTypeExclude = ['markdown', 'text']

  " 缩进线颜色方案使用 SpecialKey 高亮组.
  let g:indentLine_defaultGroup = 'SpecialKey'
endif

"""""" 'voldikss/vim-floaterm'
" doc: https://github.com/voldikss/vim-floaterm
" FIXME: 使用 Vim 的情况, floaterm 的颜色方案和 Vim 的不一致, 使用 Neovim 无此问题.

if &rtp =~ '/vim-floaterm,'
  " 显示或隐藏悬浮终端窗口, 如果悬浮窗口还不存在则新建.
  let g:floaterm_keymap_toggle = '<leader>,t'

  " 新建一个悬浮窗口.
  let g:floaterm_keymap_new = '<leader>tc'

  " 关闭当前悬浮窗口.
  let g:floaterm_keymap_kill = '<leader>tk'

  " 切换到下一个悬浮窗口.
  let g:floaterm_keymap_next = '<leader>tn'

  " 显示目前存在的悬浮窗口.
  let g:floaterm_keymap_show = '<leader>ts'
endif

"""""" 'uguu-org/vim-matrix-screensaver'
" doc: https://github.com/uguu-org/vim-matrix-screensaver

if &rtp =~ '/vim-matrix-screensaver,'
  " 在当前 Vim 窗口启用 Matrix 屏幕保护.
  nmap <leader>m :Matrix<CR>
endif

"""""" machakann/vim-highlightedyank
" doc: https://github.com/machakann/vim-highlightedyank

if &rtp =~ '/vim-highlightedyank,'
  " 被复制的文本对象的高亮颜色显示的时间, 单位毫秒.
  " 如果值为 -1, 则表示高亮颜色永久显示.
  let g:highlightedyank_highlight_duration = 1000

  " 解决个别主题或 terminal 配置下高亮不生效的问题, 一般可不配置此项.
  highlight HighlightedyankRegion cterm=reverse gui=reverse
endif

"""""" unblevable/quick-scope
" doc: https://github.com/unblevable/quick-scope

if &rtp =~ '/quick-scope,'
  " 是否禁用此插件, 默认值1, 表示启用.
  let g:qs_enable=1

  " 性能考虑, 是否延迟显示高亮字符, 默认值: 0, 表示实时显示.
  let g:qs_lazy_highlight = 0
endif

"""""" 'ryanoasis/vim-devicons'
" doc: https://github.com/ryanoasis/vim-devicons
" NOTE: 1. 需要提前为你的终端模拟器(terminal emulator)设置如下字体:
"   Hack Nerd Font 或 Hack Nerd Font Mono
" 2. Hack Nerd Font 字体安装(macOS):
"   brew tap homebrew/cask-fonts && brew install font-hack-nerd-font

if &rtp =~ '/vim-devicons,'
  " 是否启用文件类型图标显示, 默认值: 1, 表示启用.
  let g:webdevicons_enable = 1

  " 为 gvim/mvim(GUI) 设置字体和字号.
  set guifont=Hack_Nerd_Font:h12
endif

" }}

" 其他插件配置  Configuration Other Plugins {{

"""""" skywind3000/asyncrun.vim
" doc: https://github.com/skywind3000/asyncrun.vim

if &rtp =~ '/asyncrun.vim,'
  " ,ar  在 command-line 模式下输入要异步执行的命令, 并在当前窗口底部输出执行结果.
  " NOTE: 这里使用 exec 包装一层, 是为了不让行尾空格直接暴露出来,
  " 所以通过使用 exec 的方式, 就可以将原来行尾的空格包裹起来了.
  exec "nnoremap <leader>ar :AsyncRun -mode=term -pos=bottom -rows=10 "
endif

"""""" RRethy/vim-hexokinase
" doc: https://github.com/RRethy/vim-hexokinase

if &rtp =~ '/vim-hexokinase,'
  " 显示或不显示颜色标识符的颜色.
  au FileType * nmap <leader>ys :HexokinaseToggle<CR>

  " 支持哪些展示颜色的方式.
  " 支持的展示方式: virtual,sign_column,background,backgroundfull,foreground,foregroundfull
  if has('nvim')
    let g:Hexokinase_highlighters = [
      \  'virtual',
      \  'sign_column',
      \  'foregroundfull',
      \ ]
  else
    let g:Hexokinase_highlighters = [
      \  'sign_column',
      \  'foregroundfull',
      \ ]
  endif

  " 匹配哪些类型的颜色标识.
  " 支持颜色类型: full_hex,triple_hex,rgb,rgba,hsl,hsla,colour_names
  let g:Hexokinase_optInPatterns = [
    \  'full_hex',
    \  'triple_hex',
    \  'rgb',
    \  'rgba',
    \  'hsl',
    \  'hsla',
    \ ]

  " 针对文件类型定制需要匹配的颜色类型.
  let g:Hexokinase_ftOptInPatterns = {
    \  'css': 'full_hex,rgb,rgba,hsl,hsla,colour_names',
    \  'html': 'full_hex,rgb,rgba,hsl,hsla,colour_names'
    \ }

  " 对哪些文件类型提供该插件提供的功能.
  " NOTE: 默认对所有文件都启用, 如果只想对部分文件类型启用, 则通过下面这条指令配置.
  "let g:Hexokinase_ftEnabled = ['css', 'html', 'javascript']

  " 对哪些文件类型禁用该插件提供的功能, 默认值空列表.
  let g:Hexokinase_ftDisabled = []
endif

"""""" vim-scripts/SyntaxAttr.vim
" doc: https://github.com/vim-scripts/SyntaxAttr.vim

if &rtp =~ '/SyntaxAttr.vim,'
  " ,a  显示光标所在的语法高亮详情, 便于调试配色方案.
  "
  " 举例:
  "    group: goComment->Comment guifg=#585858(#585858) gui=italic
  "    如上结果表示, 光标所在属于 goComment 语法加亮组, 并且被链接到了 Comment 加亮组,
  "    guifg 和 gui 是加亮组的值, guifg 表示前景色, gui 表示特殊效果.
  nnoremap <leader>a :call SyntaxAttr()<CR>
endif

"""""" takac/vim-hardtime
" doc: https://github.com/takac/vim-hardtime

if &rtp =~ '/vim-hardtime,'
  " 是否使每一个窗口 buffer 都应用此插件功能, 默认值: 0
  let g:hardtime_default_on = 1

  " 连续按 jklh 等命令时, 禁止连续按的超时时间, 默认值: 1000毫秒.
  let g:hardtime_timeout = 600

  " 启用 hardtime 模式后, 是否进行模式已启用的提示, 默认值: 0, 表示不提示.
  let g:hardtime_showmsg = 1

  " 是否允许连续按2个不同的简单指令, 比如 jh, 默认值: 0, 表示不允许.
  let g:hardtime_allow_different_key = 1

  " 允许连续按几次简单命令, 默认值: 1
  let g:hardtime_maxcount = 3
endif

" }}

" 常用原生选项  Native Configuration {{

" 显示当前光标所在的行号和列号.
set ruler

" 命令行窗口的高度, 默认值7.
" 命令行窗口打开的方法:
"   1) command-line 模式下, 按快捷键 ctrl f 打开命令行窗口并显示命令历史记录.
"   2) normal 模式下, 按快捷键 q: 打开命令行窗口并显示命令历史记录.
"   3) normal 模式下, 按快捷键 q/ 将会打开命令行窗口并显示向下搜索的历史记录.
"   4) normal 模式下, 按快捷键 q? 将会打开命令行窗口并显示向上搜索的历史记录.
set cmdwinheight=8

" 突出显示当前行.
set cursorline

" 突出显示当前列.
set cursorcolumn

" 显示括号匹配.
set showmatch

" normal 模式下显示输入的 Vim 命令.
set showcmd

" 一个 tab 显示几个空格长度, 默认是 8 个空格, 这里改为 4 个空格.
set ts=4

" 将 tab 缩进用空格来表示, 提高效率.
set expandtab

" insert 模式下按退格键的时候退回缩进的长度为 4 个空格, 默认是退回一个空格.
set softtabstop=4

" normal 模式下 >> 和 << 或 visual 模式下 > 和 < 每次缩进 4 个空格, 默认是 8 个空格.
set shiftwidth=4

" 缩进时取整.
" Use multiple of shiftwidth when indenting with '<' and '>'
set shiftround

" 启用智能缩进, 按回车键后自动缩进,
" 注意启用此模式后, 粘贴代码时要先 :set paste
set smartindent

" 进行搜索时会快速找到结果, 随着输入的字符进行及时匹配.
set incsearch

" 搜索关键字高亮显示.
set hlsearch

" 搜索时忽略大小写.
set ignorecase

" 如果同时打开了ignorecase, 那么对于搜索只有一个大写字母的搜索词, 将大小写敏感;
" 其他情况都是大小写不敏感, 比如: 搜索 Test 时, 将不匹配 test,
" 但搜索 test 时, 将匹配 Test.
set smartcase

" 不创建备份文件. 默认情况下, 文件保存时, 会额外创建一个备份文件,
" 它的文件名是在原文件名的末尾, 再添加一个波浪号(〜).
set nobackup

" 出错时不要发出响声.
set noerrorbells

" 打字的时候隐藏鼠标光标.
set mousehide

" 在修改内容后保存文件, 如果文件同时已经被其他 Vim 实例打开,
" 则其他 Vim 实例打开的此文件也会自动同步变更.
set autoread
au FocusGained,BufEnter * checktime

" normal 模式下允许光标移动到最后一个字符的右边.
set virtualedit=onemore

" 一行内容超过终端宽度时进行折行显示.
set wrap

" 当一行字符长度超过多少个字符时, 会自动折行显示, 注意会加上换行符.
set lbr
set textwidth=500

" 基于性能考虑, 执行宏命令的时候不进行 redraw 动作.
set lazyredraw

" }}

" 自定义配置  Custom Configuration {{

"""""" 设置行号  Number/RelativeNumber {{

" 显示相对行号, 便于跨行的文本对象操作, 比如: [n]j/k/y/v/c/d 等.
set relativenumber number

" 使查看 Vim 帮助文档的窗口也显示相对行号.
augroup vim help
  autocmd!
  autocmd FileType help,man setlocal number
  autocmd FileType help,man setlocal relativenumber
augroup END

" 失去焦点时(比如光标从当前 buffer 移走), 不显示相对行号, 而是显示正常行号.
au FocusLost * :set norelativenumber number
au FocusGained * :set relativenumber

" insert 模式下用绝对行号, normal 模式下用相对行号.
autocmd InsertEnter * :set norelativenumber number
autocmd InsertLeave * :set relativenumber

" ,n  显示或隐藏行号.
nnoremap <leader>n :call ToggleNumberShow()<CR>
function! ToggleNumberShow()
  if(&relativenumber == 1)
    set norelativenumber nonumber
  else
    set relativenumber
  endif
endfunc

" }}

"""""" 标签页管理 Tabs Management {{

" 标签页切换:
"
"   g tab  normal 模式下切换到上一次访问的标签页;
"   gt/gT  normal 模式下切换到下一个/上一个标签页;
"
"   , 1/2/3/4/5/6/7/8/9  normal 模式下切换到具体的某一个标签页;
"   , 0  normal 模式下切换到最后一个标签页.
noremap <silent> <leader>1 1gt<CR>
noremap <silent> <leader>2 2gt<CR>
noremap <silent> <leader>3 3gt<CR>
noremap <silent> <leader>4 4gt<CR>
noremap <silent> <leader>5 5gt<CR>
noremap <silent> <leader>6 6gt<CR>
noremap <silent> <leader>7 7gt<CR>
noremap <silent> <leader>8 8gt<CR>
noremap <silent> <leader>9 9gt<CR>
noremap <silent> <leader>0 :tablast<CR>

"   Option/Alt 1/2/3/4/5/6/7/8/9  normal/insert 模式下切换到具体的某一个标签页;
"   Option/Alt 0  normal/insert 模式下切换到最后一个标签页.
noremap <silent> <M-1> :tabn 1<CR>
noremap <silent> <M-2> :tabn 2<CR>
noremap <silent> <M-3> :tabn 3<CR>
noremap <silent> <M-4> :tabn 4<CR>
noremap <silent> <M-5> :tabn 5<CR>
noremap <silent> <M-6> :tabn 6<CR>
noremap <silent> <M-7> :tabn 7<CR>
noremap <silent> <M-8> :tabn 8<CR>
noremap <silent> <M-9> :tabn 9<CR>
noremap <silent> <M-0> :tablast<CR>
inoremap <silent> <M-1> <esc>:tabn 1<CR>
inoremap <silent> <M-2> <esc>:tabn 2<CR>
inoremap <silent> <M-3> <esc>:tabn 3<CR>
inoremap <silent> <M-4> <esc>:tabn 4<CR>
inoremap <silent> <M-5> <esc>:tabn 5<CR>
inoremap <silent> <M-6> <esc>:tabn 6<CR>
inoremap <silent> <M-7> <esc>:tabn 7<CR>
inoremap <silent> <M-8> <esc>:tabn 8<CR>
inoremap <silent> <M-9> <esc>:tabn 9<CR>
inoremap <silent> <M-0> <esc>:tablast<CR>

"   ,fn  切换到下一个标签页;
"   ,fp  切换到上一个标签页.
noremap <silent> <leader>fn :tabnext<CR>
noremap <silent> <leader>fp :tabprev<CR>

" 标签页创建:
"   Ctrl t  normal/insert 模式下创建新的标签页.
noremap <silent> <C-t> :tabnew<CR>
inoremap <silent> <C-t> <esc>:tabnew<CR>

" 标签页关闭:
"   ,qo  只保留当前的标签页, 关闭其他所有标签页;
"   ,qq  关闭当前标签页;
"   ,q 1/2/3...  关闭指定序号的标签页;
"   ,q 0  关闭最后一个标签页.
noremap <silent> <leader>qo :tabonly<CR>
noremap <silent> <leader>qq :tabclose<CR>
noremap <silent> <leader>q1 :tabclose 1<CR>
noremap <silent> <leader>q2 :tabclose 2<CR>
noremap <silent> <leader>q3 :tabclose 3<CR>
noremap <silent> <leader>q4 :tabclose 4<CR>
noremap <silent> <leader>q5 :tabclose 5<CR>
noremap <silent> <leader>q6 :tabclose 6<CR>
noremap <silent> <leader>q7 :tabclose 7<CR>
noremap <silent> <leader>q8 :tabclose 8<CR>
noremap <silent> <leader>q9 :tabclose 9<CR>
noremap <silent> <leader>q0 :tabclose $<CR>

" }}

"""""" 撤销更改提示  Undo Warnings {{
"
" from: https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup/blob/master/plugin/undowarnings.vim
"
" 此段代码的作用:
" 在希望通过 undofile 的配置来无限制的对曾经的编辑进行撤销,
" 同时还希望在退回打开文件的状态之前能有一个提醒.
"

" Vim global plugin adding warnings to persistent undo
" Last change:  Tue Jun 19 17:25:10 EST 2012
" Maintainer:	Damian Conway
" License:	This file is placed in the public domain.

" If already loaded, we're done...
if exists("loaded_undowarnings")
  finish
endif
let loaded_undowarnings = 1

" Preserve external compatibility options, then enable full vim compatibility...
let s:save_cpo = &cpo
set cpo&vim

"=====[ INTERFACE ]==================

" Remap the undo key to warn about stepping back into a buffer's pre-history...
nnoremap <expr> u  VerifyUndo()

" =====[ IMPLEMENTATION ]==================
"
" Track each buffer's starting position in the undo history...
augroup UndoWarnings
  autocmd!
  autocmd BufReadPost,BufNewFile * :call Rememberundo_start()
augroup END

function! Rememberundo_start ()
  let b:undo_start = exists('b:undo_start') ? b:undo_start : undotree().seq_cur
endfunction

function! VerifyUndo ()
  " Nothing to verify if can't undo into previous sesssion...
  if !exists('*undotree')
    return 'u'
  endif

  " Are we back at the start of this session (but still with undos possible)???
  let undo_now = undotree().seq_cur

  " If so, check whether to undo into pre-history...
  if undo_now > 0 && undo_now == b:undo_start
    return confirm('',"Undo into previous session? (&Yes\n&No)",1) == 1 ? "\<C-L>u" : "\<C-L>"
  " Otherwise, always undo...
  else
    return 'u'
  endif
endfunction

" Restore previous external compatibility options
let &cpo = s:save_cpo

" }}

"""""" 光标移动  Cursor Movement {{

" ctrl u/d  normal 模式下, 光标向上或向下移动的时候,
" 从默认的每次移动半屏改为移动 10 行.
noremap <C-u> 10k
noremap <C-d> 10j

" 将在多窗口之间进行上下左右跳转光标的快捷键重新映射:
"   ctrl h  跳转到左边的窗口;
"   ctrl l  跳转到右边的窗口;
"   ctrl k  跳转到上面的窗口;
"   ctrl j  跳转到下面的窗口.
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" insert 模式下使用 emacs 键位.
" 光标移动:
"   ctrl p 上
"   ctrl n 下
"   ctrl a 行首
"   ctrl e 行尾
" NOTE: 1) 如果 tmux 将 ctrl a 作为 prefix, 则这里需要按两次 ctrl a.
" 2) 如下两个快捷键已在 coc.nvim 插件的配置中配置, 此处不要重复配置.
"    ctrl b 左
"    ctrl f 右
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-a> <Home>
inoremap <C-e> <End>

" Option/Alt b/f  insert 模式下将光标向左或向右移动一个单词.
inoremap <M-b> <S-Left>
inoremap <M-f> <S-Right>

" command-line 模式下使用 emacs 键位, :h emacs-keys
" 光标移动:
"   ctrl a 移动到行首.
"   ctrl e 移动到行尾.
"   ctrl b 向左移动一个字符.
"   ctrl f 向右移动一个字符.
cnoremap <C-a>  <Home>
cnoremap <C-e>  <End>
cnoremap <C-b>  <Left>
cnoremap <C-f>  <Right>

" Option/Alt b/f  command-line 模式下将光标向左或向右移动一个单词.
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

" normal/visual 模式下, 按 0 光标将回到当前行的第一个非空字符,
"               如果光标已经在第一个非空字符, 则回到行首.
" insert 模式下, 按 ctrl a 光标将回到当前行的第一个非空字符,
"        如果光标已经在第一个非空字符, 则回到行首.
function! GoToFirstNonBlankOrFirstColumn()
  let cur_col = col('.')
  normal! ^
  if cur_col != 1 && cur_col == col('.')
    normal! 0
  endif
  return ''
endfunction
nnoremap <silent> 0 :call GoToFirstNonBlankOrFirstColumn()<CR>
vnoremap <silent> 0 :call GoToFirstNonBlankOrFirstColumn()<CR>
inoremap <silent> <C-a> <C-R>=GoToFirstNonBlankOrFirstColumn()<CR>

" n/N/*/#  搜索关键字后每次跳转都将目标显示在屏幕中间区域.
" Keep search pattern at the center of the screen.
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz

" }}

"""""" 文本编辑  Text Edit {{

" insert 模式下的编辑动作:
"   ctrl l 向右删除一个字符.
"   ctrl d 从光标位置删除到行尾.
" NOTE: 如下两个快捷键是默认行为, 无需额外配置.
"   ctrl h 向左删除一个字符.
"   ctrl w 向左删除一个单词.
"   ctrl u 从光标位置删除到行首.
inoremap <C-l> <Del>
inoremap <C-d> <C-[>Di

" command-line 模式下的编辑动作:
"   ctrl l 删除光标右侧字符;
" NOTE: 如下两个快捷键是默认行为, 无需额外配置.
"   ctrl h 删除光标左侧字符;
"   ctrl w 删除光标左侧一个单词.
cnoremap <C-l> <Del>

" visual 模式下进行 > 和 < 缩进操作时,
" 使不退出 visual 模式, 这样可方便执行多行的连续缩进.
vnoremap < <gv
vnoremap > >gv

" visual 模式下选择内容, 然后通过按 ,) 或 ,] 或 ,} 或 ," 或 ,' 或 ,`
" 将选择的内容使用 () 或 [] 或 {} 或 "" 或 '' 或 `` 包裹.
vnoremap <leader>) <esc>`>a)<esc>`<i(<esc>
vnoremap <leader>] <esc>`>a]<esc>`<i[<esc>
vnoremap <leader>} <esc>`>a}<esc>`<i{<esc>
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>
vnoremap <leader>` <esc>`>a`<esc>`<i`<esc>

" }}

"""""" 键位绑定  Other Keybindings {{

" ,E  打开 vim 或 nvim 的配置文件.
if has('nvim')
  noremap <silent> <leader>E :sp ~/.config/nvim/init.vim<CR>
else
  noremap <silent> <leader>E :sp ~/.vimrc<CR>
endif

" ,R  变更配置文件后不需要退出再打开文件, 直接使用此命令进行 reload 生效.
if has('nvim')
  noremap <silent> <leader>R :source ~/.config/nvim/init.vim<CR>:filetype detect<CR>
    \ :exe ":echo '~/.config/nvim/init.vim reloaded'"<CR>
else
  noremap <silent> <leader>R :source ~/.vimrc<CR>:filetype detect<CR>
    \ :exe ":echo '~/.vimrc reloaded'"<CR>
endif

" ctrl s  在 normal/insert 模式下打开/关闭英文的拼写检查.
" NOTE: 1) 有了 spell 后的 ! 就可以支持 toggle 了, 也就是既支持打开又支持关闭;
" 2) <C-o> 和 :setlocal 之间不能有空格.
nmap <silent> <C-s> :setlocal spell! spelllang=en,cjk<CR>
imap <silent> <C-s> <C-o>:setlocal spell! spelllang=en,cjk<CR>

" ctrl e/y  normal 模式下, 向下或向上移动屏幕阅读的时候,
" 从默认的每次移动 1 行改为移动 3 行.
noremap <C-e> 3<C-e>
noremap <C-y> 3<C-y>

" Y  normal 模式下, 使用 Y 复制当前行光标之后的内容, 和 C 和 D 用法统一起来.
nnoremap Y y$

" 选中当前文件所有行、当前行到最后一行、当前行到第一行,
" 选中之后可以进行一系列编辑动作, 比如 y/d/c 等等.
" ,va  Select all lines.
map <Leader>va ggVG
" ,vf  Select from the current line to the end of line.
map <Leader>vf VG
" ,vb  Select from the current line to the first of line.
map <Leader>vb Vgg

" 拷贝当前文件所有行、当前行到最后一行、当前行到第一行,
" ,ya  Yank all lines.
map <Leader>ya ggVGy
" ,yf  Yank from the current line to the end of line.
map <Leader>yf VGy
" ,yb  Yank from the current line to the first of line.
map <Leader>yb Vggy

" 拷贝当前文件全路径.
map <silent> <Leader>cp :let @+=expand("%:p")<CR>

" :W  普通用户没有权限时使用 sudo 权限保存文件.
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" ,z  当一个界面上有多个窗口时, 可以放大或还原当前所在的子窗口.
" Zoom windows.
" from: http://stackoverflow.com/questions/13194428/is-better-way-to-zoom-windows-in-vim-than-zoomwin
nnoremap <silent> <leader>z :ZoomToggle<CR>

function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()

" }}

"""""" 其他配置  Other Settings {{

" 每次从insert模式切换到normal模式时自动切换输入法为英文.
" 需提前安装im-select命令:
" curl -Ls -o /usr/local/bin/im-select https://github.com/daipeihust/im-select/raw/master/macOS/out/apple/im-select
" chmod 755 /usr/local/bin/im-select
"autocmd InsertLeave * :silent !/usr/local/bin/im-select com.apple.keylayout.ABC

" 解决中文乱码问题.
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" 第 80 列通过颜色标注, 提示我们对单行代码长度的掌控.
autocmd FileType * set colorcolumn=80

" tab 键显示为 >---, 行尾空格显示为 -, 帮助我们及时发现多余的空白字符.
function! SetList()
  if &filetype != 'go'
    set list listchars=tab:>-,trail:-
  endif
endfunction
autocmd FileType * call SetList()

" 重新打开文件时, 光标恢复在上次离开时的位置.
augroup resCur
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END

" command-line 模式下, 操作指令按下 tab 键自动补全:
" 第 1 次按下 tab, 会显示所有匹配的操作指令的清单, 第 2 次按下 tab, 会依次选择各个指令.
set wildmenu
set wildmode=longest:list,full

" 忽略无用的编译类等文件.
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" insert 模式下使用 <BS> <Del> <C-W> <C-U>, 解决无法回退删除等问题, 比如按 backspace 键无反应.
set backspace=indent,eol,start
set whichwrap+=<,>,h,l

" 保留撤销历史, Vim 会在编辑时保存操作历史, 用来供用户撤消更改;
" 默认情况下, 操作记录只在本次编辑时有效, 一旦编辑结束、文件关闭, 操作历史就消失了;
" 打开这个设置, 可以在文件关闭后, 操作记录保留在一个文件里面继续存在.
" 这意味着, 重新打开一个文件, 可以撤销上一次编辑时的操作;
" 撤消文件是跟原文件保存在一起的隐藏文件, 文件名以 .un~ 开头.
set undofile
set undodir=~/.vim/undo
if !isdirectory(&undodir)
  call mkdir(&undodir, 'p', 0700)
endif

" normal 模式下的 nyy 复制(n 为数字), 或进入 visual 模式下选择内容后的 y 复制,
" 除了可以将复制的内容粘贴(使用 p)到其他 Vim 实例,
" 还可以将内容粘贴(command v)到系统的其他任何可输入窗口.
"
" 注意: 以上所说的都是针对本地操作系统使用本地 Vim 的情况,
" 比如 macOS/Windows/Linux 本地的 Vim 和本地的其他应用窗口之间,
" 不包括远程连接的操作系统的 Vim 和本地应用的窗口之间.
if has('clipboard')
  if has('unnamedplus')
    set clipboard=unnamed,unnamedplus " for Linux
  else
    set clipboard=unnamed " for macOS、Windows
  endif
endif

" 从额外的本地配置文件(如果存在的话)加载配置.
let vimrc_local = $HOME . '/.vimrc.local'
if filereadable(expand(vimrc_local))
  exec 'source' vimrc_local
endif

" }}

" }}

" 备用配置  Stand-by Configuration {{

" 将 sign 列合并到行号列, 会影响到 [n]k/j 快速跳转到指定行, 所以不建议开启此配置.
"set signcolumn=number

" sign 列始终显示, 根据个人喜好决定是否启用.
"set signcolumn=yes

" 输入的文字到达终端边缘时不自动折行, 所谓折行指的是一行内容视觉上显示为多行,
" 不是真正的加换行符的换行.
"set nowrap

" 保存文件时自动去除行尾空格, 注意已经通过 ale 配置, 此条注释不再使用.
"autocmd BufWritePre *.sh,*.lua,*.js,*.html,*.vue,*.toml,*.yaml,*.yml :%s/\s\+$//e

" 退出 insert 模式时指定类型的文件将自动保存.
"au InsertLeave *.go,*.lua,*.sh,*.py,*.js,*.md write

" 退出文件后, 屏幕依然显示该文件内容.
"set t_ti= t_te=

" 覆盖掉默认的拼写检查设置, 不启用拼写检查.
"autocmd VimEnter * set nospell

" 不创建交换文件, 交换文件主要用于系统崩溃时恢复文件, 文件名以 . 开头, 文件后缀是 .swp
"set noswapfile

" 出错时, 发出视觉提示, 通常是屏幕闪烁.
"set visualbell

" 关闭方向键, 强制用 hjkl.
"map <Left> <Nop>
"map <Right> <Nop>
"map <Up> <Nop>
"map <Down> <Nop>

" 根据光标所在的不同tag, 动态变更文件类型.
" function! s:setFileType()
"   if searchpair('<script', '', '</script>', 'bnW')
"     set ft=javascript
"   elseif searchpair('<style', '', '</style>', 'bnW')
"     set ft=css
"   else
"     set ft=html
"   endif
" endfunction

" augroup vueBinds
"   au!
"   au CursorMoved,CursorMovedI *.vue call s:setFileType()
" augroup END

" }}

" 使用技巧  Tips {{

"""""""""" 常用命令行 {{
"
" vim/nvim --version                     可以查看到全局和用户级别的配置文件的加载顺序等信息.
" vim -g 或 mvim 或 gvim                 macOS 下运行 Vim 的图形界面模式, 需安装 macvim.
" vim -c 'normal 5G36|'                  normal 模式下跳转到第 5 行第 36 列.
" vimtutor                               Vim 自带的学习教程.
" vim -e --cmd 'echo $VIM|quit'          查看 $VIM 变量的值.
" vim -e --cmd 'echo $VIMRUNTIME|quit'   查看 $VIMRUNTIME 变量的值.
"
" }}

"""""""""" 性能优化 {{
"
" * 无插件方式运行 Vim.
"    vim -u NONE
"
" * 将 Vim 运行的详细日志保存到 vim.log 文件中.
"    vim -V9vim.log
"
" * 记录带时间字段的启动日志, 用于优化 vim 启动时间.
"    vim --startuptime vim.log
"
" * 找出哪个插件拖慢了 Vim 的速度:
"    :profile start profile.log
"    :profile func *
"    :profile file *
"    At this point do slow actions (比如保存文件 :w 比较慢)
"    :profile pause
"    :q
"    然后查看 profile.log 文件尾部的性能分析汇总部分即可.
"
" }}

"""""""""" 常用的原生能力 {{
"
" ** 持续优化你的 vimrc 文件:
"           :version  显示当前 Vim 的版本号和支持的特性.
"     :help [object]  object 表示你要查看其文档的 Vim 某个命令或者插件名称等.
"        :h [object]  同上.
"           :h index  查询 Vim 所有键盘命令定义.
"          :h ctrl-p  查看 normal 模式下 ctrl p 快捷键的意思.
"        :h i_ctrl-p  查看 insert 模式下 ctrl p 快捷键的意思.
"                  K  1)通过上个命令打开文档, 对于有下划线的文本对象,
"                       按 K 即可直接跳转到相关的文档,
"                       ctrl o/i 可来回跳转, 增加文档阅读效率;
"                     2)在阅读 .vimrc 时, 可通过按 K 自动打开光标所在对象的文档.
"              :so %  优化变更你的 ~/.vimrc 文件内容并保存后,
"                     使用此 command-line 模式命令, 可以直接使配置生效.
"                 ,R  同上, 只不过这个是为了操作简便做的自定义配置.
"          :messages  如果出现报错信息, 但是你还没看清楚就消息就已经退出了,
"                     使用此命令可以重新看到错误信息.
"           :h error  查看 Vim 都有哪些错误信息.
"             :h E11  查看具体的某一个错误编号的释义.
"
" ** 文本对象的快捷编辑:
"
"   涉及到的常用字符说明:
"                  y  表示复制.
"                  v  表示选择, 选择后进入 visual 模式.
"                  d  表示删除.
"                  x  表示删除, 但删除对象只能是字符单位.
"                  c  表示修改, 意思是删除文本对象后进入 insert 模式等待输入新内容.
"                  s  表示修改, 但修改对象只能是字符单位,
"                     但本 vimrc 已经配置将 s 给 easymotion 插件使用.
"                  J  表示 join, 合并多行到当前行.
"
"                  l  表示光标右侧 1 个字符.
"                  h  表示光标左侧 1 个字符.
"                  e  表示光标右侧 1 个单词, end 指的是单词结尾,
"                     也就是不包含右侧紧邻的空白字符, 相当于 iw.
"                  w  表示光标右侧 1 个单词, 如右侧挨着空白字符, 则包含右侧挨着的所有空白字符,
"                     如果是 aw, 则仅包含右侧挨着的 1 个空白字符.
"                  b  表示光标左侧 1 个单词.
"                  W  表示光标右侧 1 个单词, 这里的单词是指非空白字符都是单词的组成部分,
"                     也就是以空白字符作为单词分隔符, 同样如果右侧挨着空白字符, 也包含空白字符.
"                  B  表示光标左侧 1 个单词(非空白字符也是单词的组成部分).
"                  s  sentence, 句子.
"                  p  paragraph, 段落.
"                  t  tag, html 标签.
"
"                  n  表示要操作的文本对象的数量, 不写 n 的话, 默认是 1.
"                  i  inside, 表示光标在要操作的文本对象的内部, 不包含边界.
"                  a  around, 表示光标在要操作的文本对象的内部, 包含边界.
"                  t  till, 向右到某个字符, 不包含目标字符.
"                  T  向左到某个字符, 不包含目标字符.
"                  f  forward, 向右到某个字符, 包含目标字符.
"                  F  向左到某个字符, 包含目标字符.
"
" 以上字符可按基本规则自由组合:
"       y/v/d/c [n]l  复制/选择/删除/修改光标右 n 个字符, n 可不输入, 默认是 1.
"       y/v/d/c [n]h  复制/选择/删除/修改光标左 n 个字符.
"       y/v/d/c [n]e  复制/选择/删除/修改光标右 n 个单词, 不包含右侧空白字符.
"       y/v/d/c [n]w  复制/选择/删除/修改光标右 n 个单词, 包含右侧空白字符.
"       y/v/d/c [n]W  复制/选择/删除/修改光标右 n 个单词, 特殊字符也作为单词的一部分,
"                     包含右侧空白字符.
"       y/v/d/c [n]b  复制/选择/删除/修改光标左 n 个单词.
"       y/v/d/c [n]B  复制/选择/删除/修改光标左 n 个单词, 特殊字符也作为单词的一部分.
"         y/v/d/c f*  复制/选择/删除/修改光标右侧直到 * 的文本,
"                     包含 *, * 表示一个具体的字符.
"         y/v/d/c t*  复制/选择/删除/修改光标右侧直到 * 的文本, 不包含 *,
"                     * 表示一个具体的字符.
"        [n]yy/dd/cc  复制/删除/修改 n 行.
"         y/v/d/c ip  复制/选择/删除/修改 光标所在段落.
"         y/v/d/c it  复制/选择/删除/修改 光标所在的 html 标签.
"          y/v/d/c 0  从光标位置 复制/选择/删除/修改 到行首.
"          y/v/d/c $  从光标位置 复制/选择/删除/修改 到行尾.
"         di "/(/{/[  删除 "" 或 () 或 {} 等之间的所有字符, 不包括它们本身.
"         da "/(/{/[  删除 "" 或 () 或 {} 等之间的所有字符, 也包括它们本身.
"               c2i(  删除 2 层 () 内的内容, 只留下一对 (),  并进入 insert 模式.
"                     还有很多不同组合, 请亲自尝试理解:
"                         yw/ye/yiw/y3w/yW/yi{/ya{/y3i{/yb/yB
"                         vw/ve/viw/vaw/v3iw/vW/vi{/va{/v3i{
"                         cw/ciw/c3w/cW/cb/cB
"                         dw/diw/db/dB/d3w
"                         ...
"                dgg  从光标位置删除到文件头部.
"                 dG  从光标位置删除到文件尾部.
"                dip  光标在空白行时, 使用此快捷键删除所有临近的空白行.
"                  D  删除当前行光标之后的内容.
"                  C  修改当前行光标之后的内容.
"               [n]x  剪切光标右侧 n 个字符, 同 d[n]l.
"               [n]X  剪切光标左侧 n 个字符, 同 d[n]h.
"               [n]s  修改光标后 n 个字符, 同 c[n]l.
"                     NOTE: 本 vimrc 文件配置已将 s 命令给 easymotion 插件使用.
"               [n]S  修改整行, 同 [n]cc.
"               [n]J  合并包含光标所在行在内的 n 行到当前行,
"                     如果只是 J, 则是合并下一行到光标所在行.
"                p/P  在光标 右侧/左侧 粘贴.
"               [n]r  替换当前光标右侧 n 个字符.
"                  R  进入 replace 模式, 每次按键替换一个字符,
"                     直到按 ESC 键退出 replace 模式.
"                  u  undo, 撤销最近一次的修改动作.
"                  U  撤销当前所在行的所有修改.
"             ctrl r  redo, 恢复最近一次的撤销内容.
"    :n,ms/old/new/g  将文件内第 n 行到第 m 行的所有 old 替换为 new;
"                     如果是先在 visual 模式下选择了一段内容,
"                     再按 : 则 command-line 模式栏会变为 :'<,'>,
"                     最后我们补全为 :'<,'>s/old/new/g, 即可完成替换选择的文本部分.
"      :%s/old/new/g  将文件内所有 old 替换为 new, g 表示全局替换, 如果没有 g,
"                     则每行只替换第一个匹配项.
"     :%s/old/new/gc  每个匹配串替换前先提示是否进行替换.
"             ctrl o  insert 模式下, 使临时进入 normal 模式下,
"                     执行一个 normal 命令就自动再返回 insert 模式下.
"         ctrl h/w/u  insert 模式下, 向左删除 1个字符/1个单词/到行首.
"      ctrl od l/w/e  insert 模式下, 向右删除 1个字符/1个单词/1个不含空格的单词.
"            ctrl oD  insert 模式下, 向右删除到行尾.
"
" ** 大小写转换:
"               gUiw  将单词转成大写.
"               guiw  将单词转成小写.
"                guu  将全行转成小写.
"                gUU  将全行转成大写.
"
" ** 移动光标:
"               kjhl  上下左右移动光标.
"              gk/gj  对于折行的情况, 向上/向下在折行间移动光标.
"                w/W  向右移动一个单词位置, 光标在单词开头,
"                     大写表示特殊符号也算单词的组成部分, 可前置数字表示移动的单词数量.
"                e/E  同上, 区别是移动到单词末尾.
"                b/B  向左移动一个单词位置, 光标在单词开头, 其他同 w/W.
"                  0  光标跳转到行首.
"                     NOTE: 已自定义配置为跳转到行首第一个非空字符, 再按一次才到行首.
"                  ^  光标跳转到行首第一个非空字符.
"                  $  光标跳转到行尾.
"                (/)  移动到上一句/下一句.
"                {/}  移动到上一段落/下一段落.
"                  M  光标移动到当前屏幕的中间行的行首.
"             Ngg/NG  光标移动到第 N 行.
"                 N%  光标移动到 N% 行处.
"                 N|  至第 N 列, 这里的 | 是竖线字符.
"                */#  匹配当前光标所在单词并跳转到下一个单词/上一个单词.
"                 f*  这里的 * 表示任意你要跳转到的本行字符, 比如你要跳转到 m, 则 fm,
"                     然后按 ; 继续向右匹配, 按 , 向左匹配, 直到跳转到自己想去的位置.
"                 t*  同上, 区别是不包含目标字符.
"              F*/T*  同上, 区别是方向是向左的.
"           ctrl o/i  将光标跳转到之前/之后的位置.
"           ctrl f/b  向下/向上翻整屏.
"           ctrl d/u  向下/向上翻半屏.
"           ctrl e/y  以 1 行(已自定义配置成 3 行)为单位上下移动屏幕, 而不移动光标.
"                     NOTE: 阅读的时候推荐使用这种方式, 而不是通过 jklh 或 ctrl d/u/f/b 快捷键.
"           zt/zz/zb  把光标所在行放置到屏幕的顶部、中间、底部.
"                  %  跳转到光标所在的 {([ 匹配匹配的另一端.
"                 gf  跳转到光标所在文本对象所对应的文件.
"                 gd  跳转到光标所在文本对象的定义处.
"                 `.  回到上次编辑的位置.
"
" ** 排版:
"              >>/<<  normal 模式下向 右/左 缩进4个空格.
"                >/<  visual 模式下向 右/左 缩进4个空格.
"                 ==  自动缩进.
"                :ce  本行文字居中(center).
"                :le  本行文字靠左(left).
"                :ri  本行文字靠右(right).
"
" ** 进入 insert 模式的几种方法:
"                  i  在当前光标位置插入.
"                  I  在当前行第一个非空字符前插入.
"                 gI  在行首插入.  回到上次编辑的位置.
"                  a  光标向右移动一个位置.
"                  A  光标跳转到行尾插入.
"                  o  向下新建一行插入.
"                  O  向上新建一行插入.
"
" ** visual 模式:
"                  v  进入 visual 模式.
"                  V  进入 visual line 模式.
"             ctrl v  进入 visual block 模式.
"                  o  使光标在选择范围的开头和结尾来回跳转.
"                  O  visual block 模式下除了 o 光标跳转, O 是另一种跳转方式.
"                  u  选择的区域全部转换成小写.
"                  U  选择的区域全部转换成大写.
"                  ~  选择的区域的大小写反转.
"           g ctrl g  显示选择区域的统计信息.
"
" ** 分屏/多窗口管理:
"            :sp/:vs  上下/左右 分割窗口.
"       :sp/:vs file  上下/左右 分屏创建新文件.
"            ctrl ww  光标在多个分屏窗口之间循环移动.
"     ctrl w j/k/h/l  光标移动到 下面/上面/左边/右边 的窗口.
"            ctrl wp  光标移动到上一次所在的窗口.
"              :only  多个分屏窗口的场景下, 使用此命令仅保留当前光标所在窗口, 关闭所有其他窗口.
"
" ** 对于已打开文件(buffer)的操作:
"                :ls  查看 buffer 列表.
"                :bn  切换到下一个 buffer.
"                :bp  切换到上一个 buffer.
"                :bd  删除 buffer.
"               :b 1  切换到 1 号 buffer.
"             :b abc  切换到文件名以 abc 开头的 buffer.
"
" ** 其他:
"              :help  顶部分屏打开帮助文档窗口.
"             :[tab]  command-line 模式下要擅用 tab 补全.
"          :x/:wq/ZZ  保存并退出文件.
"                 :q  不保存退出文件或关闭窗口.
"                 :!  后面输入要执行的系统命令, 回车执行.
"                  .  重复执行最近一次的修改动作.
"                  /  正向搜索模式.
"                  ?  反向搜索模式.
"                n/N  配合上面两个命令, 正向/方向跳转到搜索关键字.
"             ctrl g  显示光标所在文件的全路径, 当前文件一共多少行,
"                     光标所在行是当前文件的百分之多少的位置.
"             ctrl f  command-line 模式下, 按快捷键 ctrl f 打开命令行窗口并显示命令历史记录.
"                 q:  normal 模式下, 按快捷键 q: 打开命令行窗口并显示命令历史记录.
"                 q/  normal 模式下, 按快捷键 q/ 将会打开命令行窗口并显示向下搜索的历史记录.
"                 q?  normal 模式下, 按快捷键 q? 将会打开命令行窗口并显示向上搜索的历史记录.
"                 z=  当你拼写一个不熟悉的英文单词时, 可以使用此快捷键给出建议列表.
"                     NOTE: 需要打开英文拼写检查.
"               "ayy  将当前行拷贝到寄存器 a, a 也可以是其他字符, yy 动作也可以是其他拷贝动作.
"                "ap  将寄存器 a 中的内容粘贴到光标所在处, 我们可以拷贝不同内容到不同的寄存器,
"                     粘贴时分别选择相应的寄存器的内容进行粘贴.
"               :reg  查看当前 Vim 实例的寄存器列表.
"
" ** 不依赖插件的自定义配置提供的功能:
"                  Y  这个命令默认是复制整行的意思, 这里更改为复制光标位置到行结尾的内容.
"       ctrl b/f/p/n  insert 模式下左右上下移动光标, 或
"                     command-line 模式下向左/向右移动光标, 向上或向下翻阅历史命令.
"     Option/Alt b/f  insert/command-line 模式下, 将光标向左或向右移动一个单词.
"           ctrl a/e  insert/command-line 模式下跳转到行首/行尾,
"                     ctrl a 会跳转到行首第一个非空字符, 再按一次跳转到行首.
"           ctrl h/l  insert/command-line 模式下向左或向右删除一个字符.
"           ctrl u/d  insert/command-line 模式下从光标位置删除到行首或删除到行尾.
"             ctrl w  insert/command-line 模式下向左删除一个单词.
"      , )/]/}/"/'/`  将 visual 模式下选择的内容使用 () 或 [] 或 {} 或 "" 或 '' 或 `` 包裹.
"                 ,R  文件 ~/.vimrc 或 ~/.config/nvim/init.vim 发生变化后,
"                     正在编辑的文件不需要退出, 通过该快捷键即可重新加载该配置文件,
"                     使变更马上生效.
"                 ,E  上下分屏方式打开 ~/.vimrc 或 ~/.config/nvim/init.vim 文件.
"             ctrl s  normal/insert 模式下, 打开/关闭英文拼写检查.
"       ctrl k/j/h/l  normal 模式下, 上下左右在多窗口之间跳转.
"                 ,b  normal 模式下, 在背景是 dark 和 light 之间切换.
"                 ,o  normal 模式下, 在背景是透明和不透明之间切换.
"                ,cp  normal 模式下, 拷贝当前文件全路径到剪贴板.
"
" ** 标签页管理:
"              g tab  normal 模式下切换到上一次访问的标签页.
"              gt/gT  normal 模式下切换到下一个/上一个标签页.
"               n gt  normal 模式下切换到具体的某一个标签页.
"            , 1/2/3  normal 模式下切换到具体的某一个标签页.
"   Option/Alt 1/2/3  normal/insert 模式下切换到具体的某一个标签页.
"                ,fc  创建一个新的标签页文件.
"                ,qq  关闭当前的标签页文件.
"           ,q 1/2/3  关闭某个序号标签页.
"                ,fo  只保留当前的标签页, 关闭其他所有标签页.
"                ,fn  切换到下一个标签页.
"                ,fp  切换到上一个标签页.
"
" ** 快速输入 Markdown 语法标识符的自定义快捷键:
"                 ,b  生成粗体字标识符.
"                 ,i  生成斜体字标识符.
"                 ,s  生成删除线标识符.
"                 ,d  生成行内代码标识符.
"                 ,c  生成代码段标识符.
"                 ,m  生成代办事项标识符.
"                 ,p  生成图片链接标识符.
"                 ,a  生成超链接标识符.
"       ,1/2/3/4/5/6  生成一级到六级标题.
"                 ,l  生成水平线.
"                 ,f  以上几乎每一个快捷键都会生成一个占位符(<++>),
"                     按 ,f 光标会跳转到占位符, 并同时删除占位符.
"                 ,w  相比于 ,f 此快捷键还会增加一个换行动作.
"
" ** 其他常用技巧
"             ctrl g  状态栏显示当前buffer(文件)的文件名.
"           1 ctrl g  状态栏显示当前buffer(文件)的全路径文件名.
"           2 ctrl g  状态栏显示当前buffer(文件)的全路径文件名, 并且显示buffer编号.
"
" }}

"""""""""" 插件提供的能力 {{
"
" ** neoclide/coc.nvim (https://github.com/neoclide/coc.nvim)
"                 gl  以新建标签页的方式跳转到定义处.
"                 gy  跳转到类型定义处.
"                 gi  跳转到接口实现处.
"                 gr  在 location list 中列出相关条目, 如果只有 1 条, 则直接跳转过去.
"                  K  normal 模式下, 在悬浮窗口中查看文档.
"           ctrl f/b  在悬浮窗口中查看文档时, 或者出现代码补全提示时,
"                     如果文档或某个提示条目弹出的详细信息所在的悬浮窗口出现了滚动条,
"                     则使用此快捷键进行向下或向上翻滚页面.
"
" ** coc-translator (https://github.com/voldikss/coc-translator)
"                 ts  normal 和 visual 模式下, 将光标下的单词以弹出漂浮窗口的方式显示翻译结果.
"                tse  在状态栏下面显示翻译的结果.
"                tsr  将翻译结果替换掉光标下的单词.
"
" ** coc-git (https://github.com/neoclide/coc-git)
"                 [g  向下跳转到 git 变更处.
"                 ]g  向上跳转到 git 变更处.
"                 [c  向下跳转到 git 变更冲突处.
"                 ]c  向上跳转到 git 变更冲突处.
"                ,gd  git diff 当前 git 变更处.
"                ,gc  查看当前光标所在的 git commit 信息.
"
" ** dense-analysis/ale (https://github.com/dense-analysis/ale)
"                 :w  保存代码文件的时候, 将自动检查语法错误并提示.
"              , k/j  向上或向下跳转到下一个错误提示的位置.
"
" ** Yggdroot/LeaderF (https://github.com/Yggdroot/LeaderF)
"                ,ff  进入文件搜索的模糊搜索方式;
"             ctrl r  在 ,ff 命令的基础上, 按这个快捷键进入文件搜索的正则匹配方式;
"                ,fb  搜索当前已经打开的所有文件的内容.
"                ,fm  显示最近打开过的文件列表.
"                ,ft  显示当前文件的 tags 列表.
"                ,fl  显示当前文件的去除空行的所有行.
"                ,rg  从 normal 模式下按 ,rg 进入 command-line 模式下,
"                     然后输入要搜索的文本(支持正则表达式),
"                     回车即可显示此项目内包含此文本的文件列表;
"                     在弹出的结果窗口中, 按 gi 可以将光标移动到输入框,
"                     可以继续输入内容缩小结果列表,
"                     然后按 tab 进入结果列表中, 按 j/k 上下选择, 选择一个文件后,
"                     按 t 将以新建标签页的方式打开选择的文件.
"                 rg  visual 模式下选择文本后, 按 rg 在整个项目内搜索选择的文本, 显示搜索结果.
"                ,rc  ,rg/rg 搜索内容关闭后, 想再次搜索上次搜索的内容,
"                     normal 模式下按 ,rc 即可.
"
" ** francoiscabrol/ranger.vim (https://github.com/francoiscabrol/ranger.vim)
"                 ,r  打开 ranger, 选择文件后按 enter 或 l 以新建标签页的方式打开文件,
"                     如果文件已经打开了, 则直接跳转到相关标签页.
"
" ** terryma/vim-multiple-cursors (https://github.com/mg979/vim-visual-multi)
"             ctrl n  开启多光标模式, 默认对应 Vim 的 visual 模式.
"                n/N  开启多光标模式后, 按 n/N 向下或向上选择光标下的单词.
"                  q  取消选择当前行的目标单词并同时选择下一行的目标单词.
"                  Q  不选择当前行的目标单词.
"                tab  在多光标的 visual 模式和多光标的 normal 模式之间切换.
"              c/d/i  多光标选择完目标单词后, 对目标单词进行修改.
"                ESC  退出多光标模式.
"
" ** easymotion/vim-easymotion (https://github.com/easymotion/vim-easymotion)
"                 ,s  按此快捷键后, 再输入一个光标要跳转到的字符 x,
"                     你会发现 x 变成了另外一个字符 g, 你直接输入 g 即可完成跳转.
"                 ,w  标记所有窗口的单词.
"                 ,L  标记所有窗口的所有行首字符.
"                 ,l  标记当前行光标右侧的字符.
"                 ,h  标记当前行光标左侧的字符.
"                  s  输入1个目标字符即可高亮定位, 支持多窗口同时定位.
"
" ** tpope/vim-commentary (https://github.com/tpope/vim-commentary)
"             [n]gcc  注释或取消注释光标所在行或包含当前行的下n行.
"                 gc  visual 模式下选择多行来注释或取消注释.
"          gc[space]  normal 模式下注释或取消注释当前行.
"             gc[n]k  normal 模式下注释或取消注释当前行以及上n行, n默认为1.
"             gc[n]j  normal 模式下注释或取消注释当前行以及下n行, n默认为1.
"
" ** skywind3000/asyncrun.vim (https://github.com/skywind3000/asyncrun.vim)
"                ,ar  command-line 模式下异步运行命令, 并在当前窗口底部输出执行结果.
"
" ** fatih/vim-go (https://github.com/fatih/vim-go/wiki/Tutorial)
"   代码阅读相关:
"                  K  查看光标所在对象的帮助文档.
"                 gr  在 location list 中列出哪些地方引用了光标所在的对象.
"                ,cl  在 location list 中列出哪些地方调用了光标所在的函数.
"                 ,s  查看光标所在的类型实现了哪些接口,
"                     注意光标只能在类型或类型的方法上.
"
"   跳转到对象(函数)定义或声明处的几种方式:
"                 gd  覆盖当前页面.
"                 gl  新开一个标签页.
"                 gs  在上方分屏.
"                 gv  在右侧分屏.
"
"   代码自动生成相关:
"                ,im  自动为光标下的类型生成指定接口的实现方法.
"                ,ki  自动把光标所在的结构体字面量(仅有 value 没有 key 的情况)补充上字段.
"                ,fs  自动把光标所在的结构体字面量, 以字段零值方式补上尚未填写的字段.
"                ,ie  自动生成 if err != nil 代码段.
"                ,at  为光标所在的结构体定义自动生成字段对应的 tags.
"                ,rn  级联的重命名光标下的标识符, 重命名后, 项目内的所有与其相关的地方全部会更新.
"
"   代码运行相关:
"                ,gr  go run 当前的 go 文件.
"                ,gb  go build 当前的 go 文件, 不产生二进制文件, 只是检查是否可以成功 build.
"                ,gt  go test 当前的 go 文件.
"
" ** buoto/gotests-vim (https://github.com/buoto/gotests-vim)
"                 tt  normal 或 visual 模式下按 tt 生成光标所在函数或选择的函数的单元测试模版代码.
"                gtt  normal 或 visual 模式下按 gtt 生成当前 Go 文件的所有函数的单元测试模版代码.
"
" ** scrooloose/nerdtree (https://github.com/preservim/nerdtree)
"                 ,x  打开或关闭左侧目录树.
"                  q  关闭目录树窗口.
"                  ?  打开/关闭该插件的帮助文档.
"                o/O  展开目录/递归的展开目录, 原地再按一次则对应关闭目录.
"                x/X  闭合目录/闭合递归展开的目录,
"                     进行此操作时, 光标应该在要闭合的目录中.
"                t/T  以标签页形式打开/静默打开文件,
"                     如果光标在空目录上则新创建一个空文件并打开,
"                     然后使用 :w newfilename 来保存文件, 最后 r 来更新左侧目录树的显示.
"              gt/gT  向右/向左切换标签页.
"                3gt  切换到第 3 个标签, 切换到其他标签的方法类似.
"                  R  变更目录名称后, 更新目录树中的目录显示.
"                 CD  如果当前目录树的根目录包含了很多项目, 要将某个项目设置为目录树的根,
"                     则选择这个项目目录, 按 CD.
"                 go  选择一个文件, 按 go 只是在当前窗口展示这个文件的内容, 光标还停留在目录树窗口.
"                  I  显示/隐藏以 . 开头的文件.
"                  m  光标移动到某个文件或目录, 按 m 展示可操作的 menu 列表,
"                     选择你要的操作, 比如删除/添加/移动文件或目录等,
"                     使用 ESC 中途退出操作.
"
" ** majutsushi/tagbar (https://github.com/preservim/tagbar)
"                 ,e  打开右侧大纲窗口.
"
" ** tpope/vim-fugitive (https://github.com/tpope/vim-fugitive)
"      :Git/:Gstatus  git status
"        :Git status  git status
"              :Glog  git log
"           :Git log  类似 git log, 光标移动到一个 commit 行,
"                     然后按 o 或 O 或 enter, 打开 commit 详细内容浏览,
"                     q 退出浏览窗口, ctrl o/i 来回跳转.
"            :Gblame  git blame
"         :Git blame  git blame
"             :Gdiff  水平分屏比较当前文件与暂存区版本的区别.
"            :Gvdiff  垂直分屏比较当前文件与暂存区版本的区别, 这个更好用一点.
"          :Git diff  git diff
"
" ** junegunn/gv.vim (https://github.com/junegunn/gv.vim)
"                :GV  类似 :Git log.
"               :GV!  这个只看当前文件的 git log.
"
" ** tpope/vim-surround (https://github.com/tpope/vim-surround)
"               ysw"  使光标所在单词使用 " 包裹, 不包括光标前的字符.
"              ysiw"  光标所在的完整单词使用 " 包裹, 包括光标前的字符.
"              ysiW"  以空格作为分隔符来作为单词, 特殊符号也可以作为单词的一部分了.
"              ys3w"  以光标所在位置为起始位置向右的 3 个单词使用 " 包裹.
"               yss"  以光标所在行为单位包裹.
"                ds"  删除光标周围的双引号.
"               cs"'  把光标所在周围的双引号替换为单引号.
"               cst'  将类似 <div>hello world</div> 变为 'hello world'.
"
" ** mattn/emmet-vim (https://raw.githubusercontent.com/mattn/emmet-vim/master/TUTORIAL)
"           ctrl y ,  打开 *.html 文件:
"                     1) 输入 html:5 然后按此快捷键, 即可自动生成 html 代码模版.
"                     2) 输入 div 然后按此快捷键, 即可自动生成: <div></div>
"                     3) 输入 #foo 然后按此快捷键, 可自动生成: <div id="foo"></div>
"                     4) 输入 div>p>a , 然后按此快捷键, 可自动生成:
"                        <div><p><a href=""></a></p></div>
"
" ** instant-markdown/vim-instant-markdown (https://github.com/instant-markdown/vim-instant-markdown)
"                 ,p  打开浏览器预览当前的 markdown 文件.
"                ,,p  关闭预览.
"
" ** dhruvasagar/vim-table-mode (https://github.com/dhruvasagar/vim-table-mode)
"                ,tm  开启或关闭 table mode.
"                 ||  在 insert 模式下, 输入 || 后按 ESC 来开启 table mode.
"                 __  在 insert 模式下, 输入 __ 后按 ESC 来关闭 table mode.
"
" ** voldikss/vim-floaterm (https://github.com/voldikss/vim-floaterm)
"                ,,t  显示或隐藏悬浮终端窗口, 如果悬浮窗口还不存在则新建.
"                ,tc  新建一个悬浮窗口.
"                ,tk  关闭当前悬浮窗口.
"                ,tn  切换到下一个悬浮窗口.
"                ,ts  显示目前存在的悬浮窗口.
"
" ** rhysd/git-messenger.vim (https://github.com/rhysd/git-messenger.vim)
"                ,gm  弹出窗口显示光标下代码的 commit 信息.
"                o/O  当光标在弹出的窗口中时, 向后或向前翻阅 commit 历史.
"                  ?  当光标在弹出的窗口中时, 查看可用指令的帮助文档.
"                  q  关闭弹出的窗口.
"
" ** RRethy/vim-hexokinase (https://github.com/RRethy/vim-hexokinase)
"                ,ys  显示或不显示颜色标识符的颜色.
"
" ** vim-scripts/SyntaxAttr.vim (https://github.com/vim-scripts/SyntaxAttr.vim)
"                 ,a  显示光标所在的语法高亮详情, 便于调试配色方案.
"
" ** uguu-org/vim-matrix-screensaver (https://github.com/uguu-org/vim-matrix-screensaver)
"            :Matrix  在当前窗口启用类似黑客帝国的 Vim 屏幕保护, 按任意键退出屏保.
"                 ,m  同上.
"
" ** matze/vim-move (https://github.com/matze/vim-move)
"   [n] meta k/j/h/l  normal 模式下将光标所在行向上/向下移动 n 行,
"                     或将光标所在字符向左/向右移动 n 个字符;
"                     visual 模式下将选择的内容向上/向下移动 n 行,
"                     或将选择的内容块向左/向右移动 n 个字符.
"                     NOTE: meta 键表示 macOS 的 option 键, windows 的 alt 键.
"
" ** AndrewRadev/splitjoin.vim (https://github.com/AndrewRadev/splitjoin.vim)
"                 gS  将单行代码拆分成多行.
"                 gJ  将多行代码合并成单行.
"
" ** puremourning/vimspector (https://github.com/puremourning/vimspector)
"                ,dj  选择模版文件, 在项目的根目录创建必须的 .vimspector.json 文件.
"                ,dc  启动 debug 模式, 或运行到设置的下一个断点.
"                ,ds  停止运行 debug 模式.
"                ,dr  重新运行 debug 模式.
"                ,db  将当前光标所在行设置为断点.
"                ,dl  运行到下一行代码, 每按一次快捷键运行一样代码.
"                ,di  进入 breakpoint 所在行调用的函数内部.
"                ,do  从进入的函数中返回.
"                ,dv  查看光标所在变量的值, 注意在 debug 模式下必须运行过了这一行才可以.
"
" }}

"""""""""" 实例练习 {{
"
" ** 将 one two three four five six 改为 "one","two","four","five","six"
"                  ^  光标移动到第一个非空字符.
"           f<space>  光标移动到第一个空格.
"                 cl  删除 1 个空格并进入到 insert 模式,
"                     输入 "," 之后按 ESC 进入到 normal 模式.
"                  ;  光标跳转到下一个空格.
"                  .  重复执行步骤 3, 然后 ; 和 . 重复多次直到将所有空格都替换成 ",".
"                  I  将光标跳转到行首并进入到 insert 模式,
"                     输入 " 之后按 ESC 进入到 normal 模式.
"                  A  将光标跳转到行尾并进入到 insert 模式,
"                     输入 " 之后按 ESC 进入到 normal 模式.
"
" ** 把文件内的某个连续的行尾/或行首加上逗号:
"             ctrl v  进入 visual block 模式, 选择要操作的那些连续行.
"                  $  移动到行尾.
"                I/A  进入 insert 模式, 光标在 行首/行尾, 输入要增加的字符 `,`.
"            ESC ESC  连续按 2 次 ESC 即可.
"
" ** 将多行合并成 1 行:
"         v/V/ctrl v  进入 visual 或 visual line 或 visual block 模式.
"                  J  合并成 1 行.
"
" ** 本地编辑器之间的复制和粘贴:
"       [n]yy / Y 或 v 选择文本使用 y 复制等复制命令需要的文本对象,
"       此时默认已复制到本地系统剪贴板,
"       可在本文件、其他 Vim 实例文件 normal 模式下按 p/P 来粘贴,
"       或 insert 模式下 command v 粘贴,
"       或操作系统上的任何文本框内进行 command v 粘贴.
"
" ** 宏的使用方法举例, 比如给文本的每一行的行首和行尾都加上双引号:
"       normal 模式下按 qa,  其中 q 是宏指令, 表明开始录制宏, a 为宏的名称,
"       可以是 a-z 的任何字母, 然后我们给一行的行首和行尾都加上双引号,
"       最后 normal 模式下 q, 表示结束宏的录制;
"       接下来我们把这个宏 a 运用在每一行上, 我们选择文本所有的行,
"       然后 command-line 模式 :normal @a,
"       或者 :% normal @a, 这样所有行就都完成双引号包裹了.
"
" }}

"""""""""" 注意事项 {{
"
"   1. python-mode/python-mode  建议不要使用这个插件, 不太好用,
"      文档显示方式很蹩脚, 会影响到 coc-jedi 的正常发挥, 使用 coc-jedi 就可以了.
"
"   2. 如下 golines 配置不建议使用, 有时会严重拖慢保存文件的速度.
"      格式化 Go 代码每行的长度, 使不超过 120 个字符:
"      let g:go_fmt_command = "golines"
"      let g:go_fmt_options = {
"        \  'golines': '-m 120',
"        \  }
"
"   3. 不要拿 <Esc> 键做快捷键映射, 会拖慢从 insert 模式切换到 normal 模式的速度,
"      查看 insert 模式下当前有哪些和 <Esc> 有关的映射 :verbose imap <Esc>, 结果如下:
"      inoremap <Esc>b <S-Left>
"      inoremap <Esc>f <S-Right>
"
" }}

" }}
