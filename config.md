<!--
Add here global page variables to use throughout your
website.
The website_* must be defined for the RSS to work
-->
@def website_title = "Tomohiro Soejima"
@def website_descr = "Tomohiro Soejima's personal website"
@def website_url   = "https://tomohiro-soejima.github.io"

@def author = "Tomohiro Soejima"

@def mintoclevel = 2

<!--
Add here files or directories that should be ignored by Franklin, otherwise
these files might be copied and, if markdown, processed by Franklin which
you might not want. Indicate directories by ending the name with a `/`.
-->
@def ignore = ["node_modules/", "franklin", "franklin.pub"]

<!--
Add here global latex commands to use throughout your
pages. It can be math commands but does not need to be.
For instance:
* \newcommand{\phrase}{This is a long phrase to copy.}
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}


<!--
Defining prepath for my website
-->

@def prepath = "zaletelgroupwebsite"


\newcommand{\insertprofile}[4]{
@@row
@@container
~~~
<img class="left" src="/assets/member_profile/!#1/picture.jpg" alt="profile picture"  style="width:30%;height:auto;">
~~~
@@
[**!#2**](!#3)
~~~<br>~~~email:#4

\textinput{/assets/member_profile/!#1/profile}
~~~
<div style="clear: both"></div>
~~~
@@
}

\newcommand{\insertprofilepage}[3]{

# #2
@@row
@@container
~~~
<img class="left" src="/assets/member_profile/!#1/picture.jpg" alt="profile picture"  style="width:30%;height:auto;">
~~~
@@

email:#3

\textinput{/assets/member_profile/!#1/profile}
~~~
<div style="clear: both"></div>
~~~
@@
}

\newcommand{\publishedarticle}[5]{
@@pubs
~~~#1~~~. **!#2**

#3

arXiv: [#4](https://arxiv.org/abs/!#4), #5
@@
}

\newcommand{\publist}[1]{
```julia:./ex1
#hideall
using Cascadia, Gumbo, HTTP, Dates
r = HTTP.get("!#1")
h = parsehtml(String(r.body))
sm = Selector(".mathjax")
articles = filter(node->getattr(node, "class")=="mathjax", eachmatch(sm, h.root))

function getauthors(article)
    sm = Selector(".list-authors")
    raw_authors = eachmatch(sm, article) |> only
    authors = [children(author)[1] |> text |> strip for author in children(raw_authors) if author isa HTMLElement{:a}]
    return authors
end
function gettitle(article)
    sm = Selector(".list-title")
    raw_title = eachmatch(sm, article) |> only
    title = raw_title[2] |> text |> strip
    return title
end
function getarxiv(article)
    sm = Selector(".list-identifier")
    raw_arxiv = eachmatch(sm, article) |> only
    arxiv = getattr(raw_arxiv[1], "href") |> strip
    return arxiv[6:end]
end

function getjournalref(article)
    sm = Selector(".list-journal-ref")
    raw_journal = eachmatch(sm, article)
    if isempty(raw_journal)
        return ""
    end
    raw_journal = raw_journal |> only
    journal = raw_journal[2] |> text |> strip
    return journal
end

authors = getauthors.(articles)
titles = gettitle.(articles)
arxivs = getarxiv.(articles)
journalrefs = getjournalref.(articles)

sorted_index = sortperm(arxivs, rev=true)

authors = authors[sorted_index]
titles = titles[sorted_index]
arxivs = arxivs[sorted_index]
journalrefs = journalrefs[sorted_index]

function article_list(authors, title, arxivs, journalrefs)
    s = ""
    year = "00"
    for (ind, (author, title, arxiv, journalref)) in enumerate(zip(authors, titles, arxivs, journalrefs))
        new_year = arxiv[1:2]
        if year != new_year
            year = new_year
            s *= "## 20$year \n"
            # s *= "~~~<h2 id=\"20$year\"><a href=\"#20$year\">20$year</a></h2>~~~\n"
        end

        author_array = join(author, ", ")
        s *= "\\publishedarticle{$ind}{$title}{$author_array}{$arxiv}{$journalref}\n"
    end
    return s
end

s = article_list(authors, titles, arxivs, journalrefs)
println(s)
```

\textoutput{./ex1}
}

\newcommand{\publistarxivsearch}[1]{
```julia:./publistarxivsearch
#hideall
using Cascadia, Gumbo, HTTP, Dates
url = "!#1"
r = HTTP.get(url)
h = parsehtml(String(r.body))
sm = Selector(".arxiv-result")
articles = eachmatch(sm, h.root)

function getauthors(article)
    sm = Selector(".authors")
    raw_authors = eachmatch(sm, article) |> only
    authors = [children(author)[1] |> text |> strip for author in children(raw_authors) if author isa HTMLElement{:a}]
    return authors
end

function gettitle(article)
    sm = Selector(".title")
    raw_title = eachmatch(sm, article) |> only
    title = raw_title |> text |> strip
    return title
end

function getarxiv(article)
    sm = Selector(".list-title")
    raw_arxiv = eachmatch(sm, article) |> only
    arxiv = getattr(raw_arxiv[1], "href") |> strip
    return arxiv[23:end]
end

function getjournalref(article)
    sm = Selector(".comments")
    raw_journal = eachmatch(sm, article)

    for item in raw_journal
        if startswith(text(item), "Journal")
            return text(item)[16:end] |> strip
        end
    end

    return ""
end

authors = getauthors.(articles)
titles = gettitle.(articles)
arxivs = getarxiv.(articles)
journalrefs = getjournalref.(articles)

sorted_index = sortperm(arxivs, rev=true)

authors = authors[sorted_index]
titles = titles[sorted_index]
arxivs = arxivs[sorted_index]
journalrefs = journalrefs[sorted_index]

function article_list(authors, title, arxivs, journalrefs)
    s = ""
    year = "00"
    for (ind, (author, title, arxiv, journalref)) in enumerate(zip(authors, titles, arxivs, journalrefs))
        new_year = arxiv[1:2]
        if year != new_year
            year = new_year
            s *= "## 20$year \n"
            # s *= "~~~<h2 id=\"20$year\"><a href=\"#20$year\">20$year</a></h2>~~~\n"
        end

        author_array = join(author, ", ")
        s *= "\\publishedarticle{$ind}{$title}{$author_array}{$arxiv}{$journalref}\n"
    end
    return s
end

s = article_list(authors, titles, arxivs, journalrefs)
println(s)
```
\textoutput{./publistarxivsearch}
}