-- Inlines CSS styles, scripts, and images to create self-contained pages.
--
-- Sample configuration (with defaults):
--
-- [widgets.inline-assets]
--   widget = "inline-assets"
--
--   inline_styles = true
--   inline_scripts = true
--
--   inline_images = false
--
-- Since data URLs require a MIME type, this plugin needs a way to determine
-- the MIME type of images.
-- By default it tries to call the file(1) utility from libmagic, since it's
-- available on virtually all UNIX machines.
-- If it's not available, it uses a simple lookup table to guess by extension.
--
-- Minimum soupault version: 2.2.0
-- Author: Daniil Baturin
-- License: MIT

Plugin.require_version("2.2.0")

function get_option(table, key, default)
  if Table.has_key(table, key) then
    return table[key]
  else
    return default
  end
end

-- Retrieve config options
inline_styles = get_option(config, "inline_styles", 1)
inline_scripts = get_option(config, "inline_scripts", 1)
inline_images = get_option(config, "inline_images", 0)
delete_files = get_option(config, "delete_files", 0)

function make_asset_path(file)
  return Sys.join_path(target_dir, file)
end

---- CSS inlining ----

function inline_css_link(link_elem)
  if (HTML.get_attribute(link_elem, "rel") ~= "stylesheet") then
    Log.debug("<link> element is not a stylesheet link, ignoring")
    return
  end

  css_file = HTML.get_attribute(link_elem, "href")
  if not css_file then
    Log.warning("Ignoring a stylesheet <link> element without a \"href\" attribute")
    return
  end

  css_file_path = make_asset_path(css_file)
  if not Sys.file_exists(css_file_path) then
    Log.warning(format("CSS file %s does not exist, ignoring", css_file_path))
    return
  end

  css_data = Sys.read_file(css_file_path)

  -- Since CSS may contain special characters (like angle brackets and quotes),
  -- we cannot use HTML.create_text.
  -- We have to rely on the HTML parser knowing that text data inside <style> elements
  -- requires a special treatment.
  inline_style_elem = HTML.parse(format([[<style type="text/css">%s</style>]], css_data))

  HTML.insert_after(link_elem, inline_style_elem)
  HTML.delete(link_elem)

  if delete_files then
    Sys.delete_file(css_file_path)
  end
end

if inline_styles then
  Log.info("Inlining CSS stylesheets")
  links = HTML.select(page, "link")
  Table.iter_values(inline_css_link, links)
end

---- JavaScript inlining ----

function inline_js(script_elem)
  js_file = HTML.get_attribute(script_elem, "src")

  if not js_file then
    -- It's an inline script already, or a malformed element
    return
  end

  js_file_path = make_asset_path(js_file)
  if not js_file_path then
    Log.warning(format("JavaScript file %s does not exist, ignoring", js_file_path))
    return
  end

  js_data = Sys.read_file(js_file_path)

  -- Same issue as with CSS parsing
  new_script_elem = HTML.parse(format([[<script>%s</script>]], js_data))
  HTML.replace_element(script_elem, new_script_elem)

  if delete_files then
    Sys.delete_file(js_file_path)
  end
end

if inline_scripts then
  Log.info("Inlining scripts")
  scripts = HTML.select(page, "script")
  Table.iter_values(inline_js, scripts)
end


---- Image inlining ----

-- Fallback table of image MIME types
image_types = {}
image_types["png"]  = "image/png"
image_types["gif"]  = "image/gif"
image_types["jpg"]  = "image/jpeg"
image_types["jpeg"] = "image/jpeg"
image_types["webp"] = "image/webp"
image_types["svg"]  = "image/svg+xml"

function get_mime_type(file_path, use_libmagic)
  if use_libmagic then
    mime_type = String.trim(Sys.get_program_output(format("file --brief --mime-type %s", file_path)))
  else
    extension = strlower(Sys.get_extension(file_path))
    mime_type = image_types[extension]
  end

  return mime_type
end

-- Assume that we do have libmagic/file installed
-- We'll check if it's true before actually inlining anything
use_libmagic = 1

function inline_image(img_elem)
  image_file = HTML.get_attribute(img_elem, "src")

  if not image_file then
    Log.warning("Skipping an <img> element without an src attribute")
    return
  end

  image_file_path = make_asset_path(image_file)
  if not Sys.file_exists(image_file_path) then
    Log.warning(format("Image file %s does not exist, ignoring", image_file_path))
    return
  end

  image_data = Sys.read_file(image_file_path)
  if not image_data then
    Log.warning(format("Failed to read image file %s, skipping", image_file_path))
    return
  end

  mime_type = get_mime_type(image_file_path, use_libmagic)
  if not mime_type then
    Log.warning(format("Could not determine the MIME type of %s, skipping", image_file_path))
    return
  end

  image_data = String.base64_encode(image_data)
  data_url = format("data:%s;base64,%s", mime_type, image_data)
  HTML.set_attribute(img_elem, "src", data_url)

  if delete_files then
    Sys.delete_file(image_file_path)
  end
end

if inline_images then
  -- Check if we actually have file/libmagic
  ret = Sys.run_program_get_exit_code("file --version")
  if (ret > 0) then
    Log.warning("file/libmagic is not available, image MIME types will be guessed from extensions")
    use_libmagic = 0
  end

  Log.info("Inlining images")
  imgs = HTML.select(page, "img")
  Table.iter_values(inline_image, imgs)
end
