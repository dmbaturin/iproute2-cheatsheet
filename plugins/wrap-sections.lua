wrapper_element = config["wrapper_element"]

selector = config["selector"]

class = config["class"]
target_level = config["level"]

global_container = HTML.select_one(page, selector)
children = HTML.children(global_container)

count = size(children)
index = 1

in_section = nil

container = nil

while (index <= count) do
  child = children[index]

  h_level = HTML.get_heading_level(child)
  if not h_level then
    h_level = 0
  end

  if (h_level == target_level) then
    new_container = HTML.create_element(wrapper_element)
    HTML.add_class(new_container, class)

    HTML.insert_after(child, new_container)
    HTML.append_child(new_container, child)

    in_section = 1

    container = new_container
  elseif (h_level < target_level) and (h_level ~= 0) then
    container = nil
    in_section = nil
  else
    if in_section then
      HTML.append_child(container, child)
    end
  end

  index = index + 1
end
