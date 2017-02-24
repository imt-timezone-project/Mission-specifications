%%%%% Identification Part %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\tb@CLASSNAME{tb}
\def\tb@VERSION{1 }
\def\tb@DATE{2008/04/09}
\def\tb@DATE@fr{09/04/2008}
\def\tb@AUTHOR{Fabien Dagnat <Fabien.Dagnat@telecom-bretagne.eu>}
\newcommand*\tbClasseVersionDate{version \tb@VERSION du \tb@DATE@fr}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{\tb@CLASSNAME}[\tb@DATE]
\def\tb@ten@spaces{\@spaces\@spaces\space\space}
\def\tb@nineteen@spaces{\tb@ten@spaces\@spaces\@spaces\space}
\def\tb@fortynine@spaces{\tb@ten@spaces\tb@ten@spaces\tb@ten@spaces\tb@ten@spaces\@spaces\@spaces\space}
\def\tb@STAR@LINE{******************************************************************************^^J}
\def\tb@LINE#1{* #1 *^^J}
\def\tb@LINE@PRESENTATION{\tb@LINE{Classe pour les documents p�dagogiques du d�pt Info de T�l�com Bretagne\@spaces}}
\def\tb@LINE@AUTHOR{\tb@LINE{Auteur : \tb@AUTHOR\tb@nineteen@spaces}}
\def\tb@LINE@VERSION{\tb@LINE{Version \tb@VERSION du \tb@DATE@fr\tb@fortynine@spaces}}
\typeout{^^J\tb@STAR@LINE\tb@LINE@PRESENTATION\tb@LINE@AUTHOR\tb@LINE@VERSION\tb@STAR@LINE}

% %%%% TODO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - revoir espacement fluo
% - revoir la condition sur le fond page de titre et non pas numero 1 !
% %%%% Package loading %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[utf8]{inputenc}
\RequirePackage[francais]{babel}
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern} 
\RequirePackage{textcomp}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{ifthen}
\RequirePackage{verbatim}
\RequirePackage{fancyhdr}
%\RequirePackage{exercice}

% %%%% Meta Macros %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To create list (an empty list is nothing) 
% \tb@APPEND takes the element (1) and the list (2), it append (1) at the end of (2)
\newcommand{\tb@APPEND}[2]{%
  \edef\@tempa{#2}%
  \ifx\@tempa\@empty%
    \edef#2{#1}%
  \else%
    \edef#2{#2,#1}%
  \fi%
}
% A macro that determine if a macros is already defined
\newcommand{\tb@ISDEFINED}[2]{%
   \expandafter\ifx\csname#1\endcsname\relax%
   \else%
     \ClassWarning{\tb@CLASSNAME}{#2\space #1 is already defined}%
   \fi%
}
% Manipulating Modes, a mode is an option that enable to exclude or includeonly 
% parts of the document
% The list of modes
\def\tb@MODE@LIST{}
% Defining a new mode (argument: NAME):
% - Appends it to the mode list
% - Creates a boolean tb@mode@NAME
% - Sets it to false
\newcommand{\tb@DEFINE@MODE}[1]{%
  \tb@APPEND{#1}{\tb@MODE@LIST}%
  \newboolean{tb@mode@#1}%
  \setboolean{tb@mode@#1}{false}%
}
% Define a list of mode (argument is a comma separated list)
\newcommand{\tb@DEFINE@MODE@LIST}[1]{
  \@for\@unevar:=#1\do{%
    \tb@DEFINE@MODE{\@unevar}%
  }
}
% Manipulating Variables, a variable is a value useful for the document
% The list of modes
\def\tb@VAR@LIST{}
% Defining a new variable (argument: NAME):
% - Warns if the macro \NAME already exists
% - Appends it to the var list
% - Creates a macro \tb@var@NAME initialy containing << NAME to define >>
% - Creates a macro \showNAME printing the value of \tb@var@NAME
% - Creates a macro \NAME taking one argument that is the new content of the variable (macro \tb@var@NAME)
\RequirePackage[logonly]{trace}
\newcommand{\tb@DEFINE}[1]{
  \tb@ISDEFINED{#1}{variable}%
  \tb@APPEND{#1}{\tb@VAR@LIST}%
  \expandafter\edef\csname tb@var@#1\endcsname{#1 to define}%
  \expandafter\edef\csname show#1\endcsname{\noexpand\csname tb@var@#1\noexpand\endcsname}%
  \expandafter\edef\csname#1\endcsname##1{\noexpand\expandafter\noexpand\def\noexpand\csname tb@var@#1\noexpand\endcsname{##1}}%
}
% Define a list of variables (argument is a comma separated list)
\newcommand{\tb@DEFINE@LIST}[1]{
  \@for\@unevar:=#1\do{%
    \tb@DEFINE{\@unevar}%
  }
}
% A macro printing all defined variables and their content
\newcommand{\debug}{%
  \@for\@unevar:=\tb@VAR@LIST\do{%
    \@unevar = [\csname show\@unevar\endcsname] ; %
  }
}

% Plus besoin a priori
%\newcommand\capitalize[1]{\fup#1!}
%\def\fup#1#2!{\uppercase{#1}#2}

% %%%% Initialisations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\tb@DEFINE@MODE@LIST{%
  correction,%
  tc,msc,mastere,majeure,mineure,fip,master,fc,option,% diff�rentes formations
  cours,devoir,ficheprog,booklet,% diff�rentes formes
  gl,po,conc,archi,% g�nie logiciel ou programmation objet (pour majeure, mineure, msc, tc) concurrence (majeure) archi (fip)
  base,avance% type de FC
}
\tb@DEFINE@LIST{type,matiere,code,numero,soustitre,titre,titrecourt,soustitrecourt}% ,version => Je retire version pour la compatibilit� avec changestb (un seul fichier trouv� qui l'utilisait dans glop

% Intern usage only to detect when we are in a correction part
\newboolean{tb@boolean@inCorrection}
\setboolean{tb@boolean@inCorrection}{false}
% Intern usage only to know if there is a subtitle
\newboolean{tb@boolean@subtitle}
\setboolean{tb@boolean@subtitle}{false}
% To control the printing mode
\newboolean{tb@boolean@handout}
\setboolean{tb@boolean@handout}{false}

%%% Switchers %%%
% Controls the use of authors on the title page
\newboolean{tb@boolean@withAuthors}
\setboolean{tb@boolean@withAuthors}{false}
\newcommand*{\withAuthors}{\setboolean{tb@boolean@withAuthors}{true}}
\newcommand*{\withoutAuthors}{\setboolean{tb@boolean@withAuthors}{false}}

% Controls the use of date on the title page
\newboolean{tb@boolean@withDate}
\setboolean{tb@boolean@withDate}{false}
\newcommand*{\withDate}{\setboolean{tb@boolean@withDate}{true}}
\newcommand*{\withoutDate}{\setboolean{tb@boolean@withDate}{false}}

% Controls the inclusion of subject and correction envs
\newboolean{tb@boolean@withCorrection}
\setboolean{tb@boolean@withCorrection}{false}
\newcommand*{\withCorrection}{\setboolean{tb@boolean@withCorrection}{true}}
\newcommand*{\withoutCorrection}{\setboolean{tb@boolean@withCorrection}{false}}

% In a cours control the adding of a slide at the beginning of each section 
% it shows the section list with current section highlighted
\newboolean{tb@boolean@withSection}
\setboolean{tb@boolean@withSection}{false}
\newcommand*{\withSection}{\setboolean{tb@boolean@withSection}{true}}
\newcommand*{\withoutSection}{\setboolean{tb@boolean@withSection}{false}}

\newboolean{tb@boolean@french}
\setboolean{tb@boolean@french}{false}

% %%%% Macros utilitaires %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newbox\maboiteI%
\newbox\maboiteII%
\newcommand{\insertsep}[3]{%
  \setbox\maboiteI=\hbox{#1}%
  \setbox\maboiteII=\hbox{#3}%
  \ifdim\wd\maboiteI>0pt%
    \ifdim\wd\maboiteII>0pt%
      #1 #2 #3%
    \else%
      #1%
    \fi%
  \else%
    #3%
  \fi%
}
% %%%% Options, Class loading %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Declaration of options corresponding to modes
\@for\@unevar:=\tb@MODE@LIST\do{%
  \edef\tb@tempa{{\@unevar}{\noexpand\setboolean{tb@mode@\@unevar}{true}}}%
  \expandafter\DeclareOption\tb@tempa%
}
% Processing of modes necessary to know if it is a course or not
\ProcessOptions\relax%
\def\tb@languages{}
\DeclareOption{english}{
 \ifx\tb@languages\@empty\relax
 \def\tb@languages{english}
 \else
 \expandafter\def\expandafter\tb@languages\expandafter{\tb@languages,english}
 \fi
}%
 
\DeclareOption{french}{%TODO, if only english do not add french, possible?
  \setboolean{tb@boolean@french}{true}
  \ifx\tb@languages\@empty\relax
  \def\tb@languages{french}
  \else
  \expandafter\def\expandafter\tb@languages\expandafter{\tb@languages,french}
  \fi
}%


\DeclareOption{draft}{\setlength{\overfullrule}{5pt}}
\ExecuteOptions{french}
\ifthenelse{\boolean{tb@mode@cours}}{%
  \ifthenelse{\boolean{tb@mode@booklet}}{%
    \PassOptionsToClass{\CurrentOption,hyperref={draft=true},trans}{beamer}%
  }{}
  \DeclareOption{handout}{%
    \setboolean{tb@boolean@handout}{true}%
    \PassOptionsToClass{\CurrentOption,hyperref={draft=true}}{beamer}%
  }%
  % Forwarding all other options to beamer
  \DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}%
  \ProcessOptions\relax%
  \PassOptionsToClass{ignorenonframetext,14pt}{beamer}%
  \LoadClass{beamer}%
}{%
  \DeclareOption{handout}{\setboolean{tb@boolean@handout}{true}}%
  % Forwarding all options to article, 
  \DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}%
  \ProcessOptions\relax%
  % Some default setting: A4 paper and 12pt font
  \PassOptionsToClass{a4paper,12pt}{article}%
  \LoadClass{article}%
}
% if we need french require translate package
\ifthenelse{\boolean{tb@boolean@french}}{%
  \RequirePackage[french]{translate}%
}{}
% load all needed langages
%\RequirePackage[\tb@languages]{babel}
% load package for exercises
\RequirePackage{exercice}%
% %%%% Title page %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A macro to define the title
\renewcommand{\title}[2][]{%
  \renewcommand{\tb@var@titre}{{#2}}%
  \def\@tempa{#1}%
  \ifx\@tempa\empty%
  \renewcommand{\tb@var@titrecourt}{{#2}}%
  \else%
  \renewcommand{\tb@var@titrecourt}{{#1}}%
  \fi
}
\providecommand{\subtitle}{}%ensure \subtitle exists
\renewcommand{\subtitle}[2][]{%
  \renewcommand{\tb@var@soustitre}{{#2}}%
  \def\@tempa{#1}%
  \ifx\@tempa\empty%
    \renewcommand{\tb@var@soustitrecourt}{{#2}}%
  \else%
    \renewcommand{\tb@var@soustitrecourt}{{#1}}%
  \fi
}
\subtitle{}
\newcommand\tb@empty@title{{}}
% finally load specific package for each type of doc
\ifthenelse{\boolean{tb@mode@cours}}{%
  \RequirePackage{cours}
}{%
  \RequirePackage{texte}
}
% %%%% Variable initialisation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifthenelse{\boolean{tb@mode@fc}}{
  \type{Formation Continue}
  \numero{}
  \code{}
}{}
\ifthenelse{\boolean{tb@mode@ficheprog}}{
  \numero{Fiche Programme}
  \title{\tb@var@matiere{} \tb@var@type}
  %\subtitle{\tb@var@matiere}
  %\setboolean{tb@boolean@withAuthors}{true}
}{}

%%%%%%% TC %%%%%%%
\ifthenelse{\boolean{tb@mode@tc}}{
  \type{TC FIG}
}{}

\ifthenelse{\boolean{tb@mode@tc} \AND \boolean{tb@mode@po}}{
  \matiere{Bases de la programmation objet}
  \code{TC131D}

  \ifthenelse{\boolean{tb@mode@booklet}}{  
    \withoutAuthors
    \withoutDate
  }{%
    \withAuthors
    \withDate
  }
}{}

%%%%%%% MASTERE %%%%%%%
\ifthenelse{\boolean{tb@mode@mastere}}{
  \type{Mast�re}
  \matiere{Base en Mod. et Prog.}
  \code{ISIC302}
}{}
%%%%%%% MASTER %%%%%%%
\ifthenelse{\boolean{tb@mode@master}}{
  \type{MR2A Informatique}
  \code{}
%  \setboolean{devoir@boolean@withIdentity}{false}
  \setboolean{tb@boolean@withAuthors}{true}
}{}
%%%%%%% 3A %%%%%%%
\ifthenelse{\boolean{tb@mode@option}}{
  \type{3\ieme{} ann�e, Fili�re SLR}
  \matiere{UV IDL}
  \code{}
}{}
\ifthenelse{\boolean{tb@mode@fc} \AND \boolean{tb@mode@base}}{
  \matiere{Introduction � Java}
}{}
\ifthenelse{\boolean{tb@mode@fc} \AND \boolean{tb@mode@avance}}{
  \matiere{Java Avanc�}
}{}
%%%%%%% FIP %%%%%%%
\ifthenelse{\boolean{tb@mode@fip}}{
  \type{FIP}
}{}

\ifthenelse{\boolean{tb@mode@fip} \AND \boolean{tb@mode@po}}{
  \matiere{Programmation Objet}
  \code{INF103}
  \ifthenelse{\boolean{tb@mode@booklet}}{}{%
    \withAuthors
    \withDate
  }
}{}

\ifthenelse{\boolean{tb@mode@fip} \AND \boolean{tb@mode@archi}}{
  \matiere{UVFIP INF210}
  \code{INF211}
  \withAuthors
  \withDate
}{}
%%%%%%% MSC %%%%%%%
\ifthenelse{\boolean{tb@mode@msc}}{
  \type{Master of Science}
  \setboolean{tb@boolean@french}{false}
}{}

\ifthenelse{\boolean{tb@mode@msc} \AND \boolean{tb@mode@po}}{
  \matiere{M.Sc.}
  \code{INF3}
  \ifthenelse{\boolean{tb@mode@booklet}}{}{%
    \withAuthors
    \withDate
  }
}{}


%%%%%%% MAJEURE %%%%%%%
\ifthenelse{\boolean{tb@mode@majeure}}{
  \type{Majeure Informatique}
}{}

\ifthenelse{\boolean{tb@mode@majeure} \AND \boolean{tb@mode@po}}{
  \matiere{UV1}
  \code{INF301}
  \ifthenelse{\boolean{tb@mode@booklet}}{}{%
    \withAuthors
    \withDate
  }
}{}

\ifthenelse{\boolean{tb@mode@majeure} \AND \boolean{tb@mode@gl}}{
  \matiere{UV1}
  \code{INF301}
  \ifthenelse{\boolean{tb@mode@booklet}}{}{%
    \withAuthors
    \withDate
  }
}{}

\ifthenelse{\boolean{tb@mode@majeure} \AND \boolean{tb@mode@conc}}{
  \matiere{Syst�mes distribu�s}
  \code{INF447}
}{}

%%%%%%% MINEURE %%%%%%%
\ifthenelse{\boolean{tb@mode@mineure}}{
  \matiere{G�nie Logiciel \& Programmation Objet}
  \type{Mineure Informatique}
  \code{INF205}
}{}

% \ifthenelse{\boolean{tb@mode@po} \AND \boolean{tb@mode@gl} \AND \boolean{tb@mode@mineure}}
% {
%   \matiere{G�nie Logiciel \& Programmation Objet}
%       \code{UV1}
% }{}

% \ifthenelse{\boolean{tb@mode@po} \AND \boolean{tb@mode@mineure}}
% {
%   \matiere{Programmation Objet}
%       \code{UV1}
% }{}

% \ifthenelse{\boolean{tb@mode@gl} \AND \boolean{tb@mode@mineure}}
% {
%   \matiere{G�nie Logiciel}
%       \code{UV1}
% }{}

%\ifthenelse{\boolean{tb@mode@po}}{%
%  \ifthenelse{\boolean{tb@mode@gl}}{%
%    \ifthenelse{\boolean{tb@mode@mineure}}{
%    }
%    {\matiere{G�nie Logiciel \& Programmation Objet}
%      \code{UV1}
%    }
%  }{
%    \ifthenelse{\boolean{tb@mode@mineure}}{
%    }{
%      \code{UV1}
%      \matiere{Programmation Objet}
%    }
%  }
%}{
%  \ifthenelse{\boolean{tb@mode@gl}}{%
%    \ifthenelse{\boolean{tb@mode@mineure}}{
%    }{
%      \code{UV1}
%      \matiere{G�nie Logiciel}

%    }
%  }{}
%}
\newcommand{\modulecode}{%
  \ifthenelse{\boolean{tb@mode@mineure}}{%
    INF205%
  }{%
    \ifthenelse{\boolean{tb@mode@majeure} \AND \boolean{tb@mode@conc}}{%
      \tb@var@code%
    }{%
      \ifthenelse{\boolean{tb@mode@majeure}}{%
        UV1 - INF301%
      }{%
        \tb@var@code%
      }%
    }%
  }%
}
% %%%% Environment definitions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definition of environments corresponding to modes
% If the mode is activated (by the option), it is a do nothing env, 
% else its content is thrown away (= comment)
% Warnings go to the log file
\@for\@unevar:=\tb@MODE@LIST\do{%
  \edef\tb@tempa{\@unevar}%
  \edef\tb@tempb{\noexpand\boolean{tb@mode@\@unevar}}%
  \ifthenelse{\tb@tempb}{%
    \newenvironment{\tb@tempa}{}{}
    \ClassInfo{\tb@CLASSNAME}{\tb@tempa, will appear}%
  }{%
    \expandafter\def\csname \tb@tempa\endcsname{\comment}
    \expandafter\def\csname end\tb@tempa\endcsname{\endcomment}
    \ClassInfo{\tb@CLASSNAME}{\tb@tempa, will not appear}%
  }
}
% Definition of environment sujet and modification of correction
% - correction: text in red and indicating we are in a correction part (used for the style of listings)
% - sujet: similar to modes (but directed by the correction option)

\newcommand{\forceCorrection}{
  \colorlet{shadecolor}{red!10!white}
  \colorlet{framecolor}{red}
  \renewenvironment{correction}{%
    \setboolean{tb@boolean@inCorrection}{true}%
    \begin{breakbox}%
    }{%
    \end{breakbox}%
    \setboolean{tb@boolean@inCorrection}{false}%
  }
}

\AtBeginDocument{
  \ifthenelse{\boolean{tb@mode@correction} \OR \boolean{tb@boolean@withCorrection}}{%
    \colorlet{shadecolor}{red!10!white}
    \colorlet{framecolor}{red}
  }{
    \colorlet{shadecolor}{white}
    \colorlet{framecolor}{black}
  }
  \ifthenelse{\boolean{tb@boolean@withCorrection}}{%
    \renewenvironment{correction}{%
      \setboolean{tb@boolean@inCorrection}{true}%
      \begin{breakbox}%
    }{%
      \end{breakbox}%
      \setboolean{tb@boolean@inCorrection}{false}%
    }
  }{}
}


\ifthenelse{\boolean{tb@mode@correction}}{%
  \renewenvironment{correction}{%
    \bigskip%
    \setboolean{tb@boolean@inCorrection}{true}%
    \begin{breakbox}%
  }{%
    \end{breakbox}%
    \setboolean{tb@boolean@inCorrection}{false}%
  }
  \newenvironment{sujet}{\comment}{\endcomment}
}{%
  \newenvironment{sujet}{}{}
}

\ifthenelse{\boolean{tb@mode@booklet}}{%
  \newenvironment{notinbooklet}{\comment}{\endcomment}
}{%
  \newenvironment{notinbooklet}{}{}
}
% %%%% D�finitions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{java}

\RequirePackage{manfnt}
\newlength{\dbendheight}
\newcommand{\centereddbend}{%
  \settoheight{\dbendheight}{\dbend}%
  \divide\dbendheight by 2%
  \raisebox{\dbendheight}{\dbend}
}

\newcommand{\bfvert}[1]{{\color{green}\textbf{#1}}}

\newcommand{\moodle}[1][]{%
  \def\@tempa{#1}%
  \ifx\@tempa\@empty%
    \ifthenelse{\boolean{tb@mode@majeure}}{
      \url{http://formations.telecom-bretagne.eu/fad/course/view.php?id=23362}%
    }{}%
    \ifthenelse{\boolean{tb@mode@mineure}}{
      \url{http://formations.telecom-bretagne.eu/fad/course/view.php?id=668}%
    }{}%
    \ifthenelse{\boolean{tb@mode@option}}{
      \url{http://formations.telecom-bretagne.eu/fad/course/view.php?id=174}%
    }{}%
  \else%
    \url{http://formations.telecom-bretagne.eu/fad/course/view.php?id=#1}%  
  \fi
}

\newcommand{\mailtb}[1]{
  \href{mailto:#1@telecom-bretagne.eu}{\tt #1@telecom-bretagne.eu}
}
\newcommand{\link}[1]{
  \href{http://#1}{\tt #1}
}

\RequirePackage{calc}
\newcommand{\annexes}{
  \newbox\maboite%
  \newlength{\boitewidth}%
  \setlength{\boitewidth}{\textwidth-2\fboxsep-2\fboxrule}%
  \setbox\maboite=\hbox to \boitewidth{\hfil\Huge \textbf{Annexes}\hfil}
  \appendix%
  \vspace{1cm}\par%
  \fbox{\ht\maboite=11mm \dp\maboite=6mm\box\maboite}
  \par\vspace{5mm}
}

\newcommand{\unSchema}[4][]{%
  \begin{figure}[htbp]
    \begin{center}
      \includegraphics[#1]{#2}
    \end{center}
    \caption{#3}
    \label{#4}
  \end{figure}
}

\newcommand{\afaire}[1]{{\LARGE\textbf{\color{magenta}AFAIRE : #1}}}
\newcommand{\fluo}[1]{{\colorbox{yellow}{#1}}}

\newenvironment{remarque}{%
  \textbf{Remarque :}\par\smallskip
  \normalfont\itshape
}{%
}
\newenvironment{remarques}{%
  \textbf{Remarques :}\par\smallskip
  \normalfont\itshape\begin{itemize}
}{%
  \end{itemize}
}


\RequirePackage{newfile}
\newoutputstream{out}
\def\pscode#1#2{%
  \@bsphack
  \def\monnom{#1}
  \def\moncommentaire{#2}
  \openoutputfile{\monnom.in}{out}
  \let\do\@makeother\dospecials
  \catcode`\^^M\active
  \verbatim@startline
  \verbatim@addtoline
  \verbatim@finish
  \def\verbatim@processline{%
    \immediate\write\@nameuse{outoutstre@m}{\the\verbatim@line}}%
  \verbatim@start}
\def\endpscode{
  \closeoutputstream{out}
  \immediate\write18{buildmacro.pl \monnom}
  \@esphack
  \unSchema{\monnom}{\moncommentaire}{fig:\monnom}
}

\newcounter{fileCounter}

\def\herepscode{%
  \@bsphack
  \stepcounter{fileCounter}%
  \edef\tb@filename{herediag\@arabic\c@fileCounter}%
  \openoutputfile{\tb@filename.in}{out}
  \let\do\@makeother\dospecials
  \catcode`\^^M\active
  \verbatim@startline
  \verbatim@addtoline
  \verbatim@finish
  \def\verbatim@processline{%
    \immediate\write\@nameuse{outoutstre@m}{\the\verbatim@line}}%
  \verbatim@start}
\def\endherepscode{
  \closeoutputstream{out}
   \immediate\write18{buildmacro.pl \tb@filename}
   \@esphack
   \begin{center}
     \includegraphics{\tb@filename}
   \end{center}
 }

%%%%%%%%%%%%%%%%%%%%%  OBSOLET THINGS
\newcommand{\obsolet}[2]{
  \ClassWarning{\tb@CLASSNAME}{#1 is obsolet, you should use #2 instead}%
}
\newenvironment{exemple}{\obsolet{exemple}{example}\begin{example}}{\end{example}}
\newenvironment{defin}{\obsolet{defin}{definition}\begin{definition}}{\end{definition}}
\newenvironment{theo}{\obsolet{theo}{theorem}\begin{theorem}}{\end{theorem}}
\renewcommand{\soustitre}[1]{%
  \obsolet{soustitre}{subtitle}%
  \renewcommand{\tb@var@soustitre}{{#1}}%
}
\renewcommand{\titre}[2][]{%
  \obsolet{titre}{title}%
  \renewcommand{\tb@var@titre}{{#2}}%
  \def\@tempa{#1}%
  \ifx\@tempa\empty%
  \renewcommand{\tb@var@titrecourt}{{#2}}%
  \else%
  \renewcommand{\tb@var@titrecourt}{{#1}}%
  \fi
}
\newenvironment{exercicesimple}[1][]{
  \obsolet{exercicesimple}{exercice key body}%
  \begin{exercice}[name=#1,body=\bfseries]
}{
  \end{exercice}
}%
\newenvironment{question*}{%
  \obsolet{question*}{exercice key counter}%
  \begin{question}[counter=]
  }{
  \end{question}
}%
\newcommand{\intranet}{\obsolet{intranet}{moodle}}
