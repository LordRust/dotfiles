local c = require 'tango-dark.colors'.setup()

function load_syntax()
    return {
        Added = 'DiffAdd',
        Boolean = 'Constant',
        Change = 'DiffChange',
        Character = 'String',
        ColorColumn = { bg = c.gray },
        Comment = c.light_blue,
        Conceal = {},
        Conditional = 'Statement',
        Constant = c.light_red,
        CurSearch = { fg = c.gray, bg = c.green },
        Cursor = { bold = true },
        CursorColumn = 'ColorColumn',
        CursorIM = 'Cursor',
        CursorLine = 'ColorColumn',
        Define = 'PreProc',
        Delimiter = { fg = c.yellow, bold = true },
        DiagnosticDeprecated = { fg = c.light_red, strikethrough = true },
        DiagnosticError = c.light_red,
        DiagnosticHint = c.light_green,
        DiagnosticInfo = c.blue,
        DiagnosticOk = c.green,
        DiagnosticUnderlineError = { sp = c.light_red, undercurl = true },
        DiagnosticUnderlineHint = { sp = c.light_green, undercurl = true },
        DiagnosticUnderlineInfo = { sp = c.blue, undercurl = true },
        DiagnosticUnderlineOk = { sp = c.green, undercurl = true },
        DiagnosticUnderlineWarn = { sp = c.yellow, undercurl = true },
        DiagnosticVirtualTextError = { fg = c.light_red, italic = true },
        DiagnosticVirtualTextHint = { fg = c.light_green, italic = true },
        DiagnosticVirtualTextInfo = { fg = c.blue, italic = true },
        DiagnosticVirtualTextOk = { fg = c.green, italic = true },
        DiagnosticVirtualTextWarn = { fg = c.yellow, italic = true },
        DiagnosticWarn = c.yellow,
        DiffAdd = { bg = c.green },
        DiffChange = { bg = c.cyan },
        DiffDelete = { bg = c.light_red },
        DiffText = { bg = c.light_red },
        Directory = c.light_blue,
        EndOfBuffer = c.bg,
        Error = 'DiagnosticError',
        ErrorMsg = 'DiagnosticError',
        Exception = 'Statement',
        FloatShadow = { bg = c.gray },
        FloatShadowThrough = { bg = c.gray },
        Folded = { fg = c.yellow, bg = c.gray },
        Function = 'Identifier',
        Identifier = c.light_green,
        Include = c.light_red,
        LineNrAbove = c.gray,
        LineNrBelow = 'LineNrAbove',
        LineNr = { fg = c.purple, bold = true },
        LspCodeLens = 'LineNr',
        LspCodeLensSeparator = {},
        LspReferenceText = 'TabLineFill',
        LspSignatureActiveParameter = 'DiagnosticWarn',
        MatchParen = 'Visual',
        ModeMsg = {},
        MoreMsg = 'DiagnosticInfo',
        MsgSeparator = {},
        NonText = c.gray,
        Normal = { fg = c.fg, bg = c.bg },
        NormalFloat = { fg = c.fg, bg = c.gray },
        Operator = { fg = c.light_yellow, bold = true },
        Pmenu = { fg = c.fg, bg = c.gray },
        PmenuSbar = { bg = c.fg },
        PmenuSel = { fg = c.gray, bg = c.fg },
        PmenuThumb = { bg = c.fg },
        PreCondit = 'PreProc',
        PreProc = { fg = c.light_red, bold = true },
        Question = 'DiagnosticHint',
        QuickFixLine = {},
        RedrawDebugClear = { bg = c.yellow },
        RedrawDebugComposed = { bg = c.green },
        RedrawDebugRecompose = { bg = c.red },
        Remove = 'DiffDelete',
        Search = { fg = c.fg, bg = c.light_green },
        SignColumn = { fg = c.fg, bg = c.bg },
        SpecialChar = c.purple,
        Special = c.yellow,
        SpecialKey = 'NonText',
        SpellBad = { undercurl = true, sp = c.light_red },
        SpellCap = { undercurl = true, sp = c.light_yellow },
        SpellLocal = { undercurl = true, sp = c.light_green },
        SpellRare = { underline = true, sp = c.light_blue },
        Statement = { fg = c.light_yellow, bold = true },
        StatusLine = { fg = c.fg, bg = c.gray },
        StatusLineNC = { fg = c.gray, bg = c.gray },
        String = c.light_purple,
        Structure = 'Identifier',
        Substitute = {},
        TabLine = { fg = c.fg, bg = c.light_gray },
        TabLineFill = { bg = c.light_gray },
        TabLineSel = { fg = c.fg, bg = c.bg, bold = true },
        Tag = 'Statement',
        Title = c.fg,
        Todo = { fg = c.light_red, bg = c.light_yellow, bold = true },
        Type = { fg = c.green, bold = true },
        Underlined = { fg = c.light_blue, underline = true, sp = c.light_blue },
        VertSplit = 'LineNrAbove',
        Visual = { bg = c.purple },
        VisualNOS = {},
        WarningMsg = 'DiagnosticWarn',
        Whitespace = {},
        WildMenu = {},
        WinBar = { bg = c.bg, fg = c.gary},
        WinBarNC = 'WinBar',

        htmlH2 = c.light_red,
        htmlH1 = c.light_red,

        mkdHeading = 'htmlH1',
    }
end

function colorscheme()
    vim.api.nvim_command('hi clear')
    if vim.fn.exists('syntax_on') then
        vim.api.nvim_command('syntax reset')
    end
    vim.o.background = 'dark'
    vim.o.termguicolors = true
    vim.g.colors_name = 'tango-dark'
    local syntax = load_syntax()
    for group, colors in pairs(syntax) do
        if syntax[colors] then
            link(group, colors)
        else
            highlight(group, colors)
        end
    end
end

function link(group, color)
    vim.api.nvim_set_hl(0, group, { link = color })
end

function highlight(group, color)
    if type(color) == 'string' then
        color = { fg = color }
    end

    vim.api.nvim_set_hl(0, group, color)
end

colorscheme()
