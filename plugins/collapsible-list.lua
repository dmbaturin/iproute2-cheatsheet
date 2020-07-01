-- Converts nested lists into foldable trees
-- using HTML5 <details> elements.
--
-- Sample configuration for treeifying an <ul class="tree">:
--
-- [widgets.collapsify-list]
--   widget = "collapsible-list"
--   selector = "ul.tree"
--   collapsible_class = "collapsible"
--
-- How it works:
--  1. Find all <li> elements inside a list
--  2. If a <li> has an <ul> or <ol> child element, then:
--    2.1. Insert a <details> <summary/> </details> element into that <li>,
--         before all other elements
--    2.2. Move everything before the first <ul>/<ol> to <summary>
--    2.3. Move the first <ul>/<ol> and all that follows to <details>
--
-- Default style for foldable lists looks quite odd.
-- You can make the triangle button appear at the same level as list bullets
-- with this CSS:
--   ul.tree { list-style-position: inside; }
--   li.collapsible { list-style: none; }
--
-- Minimum soupault version: 1.12
-- Author: Daniil Baturin
-- License: MIT

Plugin.require_version("1.12")

selectors = {"ul", "ol"}

if config["selector"] then
  selectors = config["selector"]
end

collapsible_class = config["collapsible_class"]

function collapsify(elem)
  local nested_list = HTML.select_any_of(elem, {"ul", "ol"})

  if not nested_list then
    return nil
  end

  if collapsible_class then
    HTML.add_class(elem, collapsible_class)
  end

  local children = HTML.children(elem)
  local i = 1
  local count = size(children)

  local details = HTML.create_element("details")
  local summary = HTML.create_element("summary")
  HTML.append_child(details, summary)

  HTML.prepend_child(elem, details)

  while (i <= count) do
    child = children[i]
    if not HTML.is_element(child) then
      HTML.append_child(summary, child)
    else
      local tag_name = HTML.get_tag_name(child)
      if (tag_name ~= "ul") and (tag_name ~= "ol") then
        HTML.append_child(summary, child)
      else
        HTML.append_child(details, child)
      end
    end

    i = i + 1
  end
end

local elems = HTML.select_all_of(page, selectors)
local count = size(elems)
local n = 1
while (n <= count) do
  elem = elems[n]
  if HTML.is_element(elem) then
    local lis = HTML.select(elem, "li")
    local li_num = 1
    local li_count = size(lis)
    while (li_num <= li_count) do
      collapsify(lis[li_num])
      li_num = li_num + 1
    end
  end

  n = n + 1
end

