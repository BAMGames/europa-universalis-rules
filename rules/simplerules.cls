% -*- mode: LaTeX; -*-
%%%%% This file is the main class.
%%%% Administrative stuff
\def\filedate{2010/10/10}
\def\rulesversion{0.0.4}
% Probably not enough
\NeedsTeXFormat{LaTeX2e}[1996/12/01]
\ProvidesClass{simplerules}[\filedate\space v\rulesversion\space
Rules Class File, (c) JCD 2003-2010]

% Define a noindex mode (used in euTables.tex)
\newif\iftablesmode
\DeclareOption{index}{\tablesmodefalse}
\DeclareOption{noindex}{\tablesmodetrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax
\LoadClass[10pt]{report}

% Quiet inclusion of graphics
\let\Gin@log\@gobble
\RequirePackage{graphicx}
\graphicspath{{../figures/}{../blasons/}{../records/}{../pions/bitmap/}{../pions/carte/bitmap/}}
\AtBeginDocument{\global\let\Gin@log\@gobble}

%%%% Packages used

%%% Encoding
\usepackage[encapsulated]{CJK} % chinese, japanese, korean
\usepackage[nocombine]{ucs}
\usepackage[utf8x]{inputenc}
\usepackage[LUC,T1]{fontenc}

%%% Fonts
\usepackage{ttf-courier,ttf-isabella,ttf-arialnarrow}
\usepackage{bbold}
% Use real bold, not bold extended
\def\bfdefault{b}

%%% Release (fail if not present)
\input{release.sty}

%%% Tools
\usepackage{xspace}

% Custom packages
\usepackage{barlist,graytab,gametables}

\iftablesmode
\usepackage{geometry}
\let\label\@gobble
\else
\usepackage{afterpage}%,pdfpages}
\usepackage{multicol,makeidx,nameref}
% Custom packages
\usepackage{newpaper}
\fi

%%% Hyperref
\usepackage[unicode,pdfborder={0 0 0}]{hyperref}

%%% Late tools
\usepackage{pageprefix,unicodetricks,xnameref}
\XNRpagefalse

%%%% Events
\iftablesmode\else
\usepackage{EUevents}
\fi

%%% Theming

\iftablesmode
\TUallowindexfalse\TUallowlinkfalse
\AtBeginDocument{\pagestyle{empty}}
\else
\usepackage{EUtheme}
\AtBeginDocument{\pagestyle{rules}}
\makeindex
\fi
\usepackage{europa}

\def\starttest{\tracingmacros=2\tracingcommands=3\tracingassigns=1\relax}
\def\stoptest{\tracingmacros=-1\tracingcommands=-1\tracingassigns=-1\relax}
\frenchspacing