-- Extracts page modification date from git history and inserts it into the page
-- 
-- The timestamp_container_selector defines the element where the revision text is inserted (appended).
-- By default it's "body".
--
-- The timestamp_format option defined the revision text format (can include HTML tags).
-- By default it's <p>Last modified: %s</p>, but you can change it to your own Lua format string
--
-- It also allows you to override the automatic git timestamp with a manual revision date,
-- which is handy if you want to preserver the date of the last _essential_ modification
-- when you make typo fixes or formatting updates.
-- To do that, set the manual_timestamp_selector option, and if a page has an element
-- matching that selector, then its content (i.e. inner HTML) will be used for the timestamp.
--
-- To run it, you need to add something like this to soupault.conf:
-- [plugins.git-timestamp]
--   file = "plugins/git-timestamp.lua"
--
-- Then configure a widget to use it, for example:
--
-- [widgets.last-modified]
--   widget = "git-timestamp"
--   timestamp_container_selector = "div#content"
--   manual_timestamp_selector = "time#last-modified"
--   timestamp_format = "<p>Last modified on %s</p>"
--   git_date_format = "format:%Y-%m-%d"
--
-- Author: Daniil Baturin
-- License: MIT

Plugin.require_version("1.9")

manual_timestamp_selector = config["manual_timestamp_selector"]
timestamp_container_selector = config["timestamp_container_selector"]
timestamp_format = config["timestamp_format"]
git_date_format = config["git_date_format"]


if not timestamp_format then
  timestamp_format = "<p>Last modified: %s</p>"
end

if not timestamp_container_selector then
  timestamp_container_selector = "body"
end

if not git_date_format then
  git_date_format = "short"
end

if manual_timestamp_selector then
  timestamp_elem = HTML.select_one(page, manual_timestamp_selector)
  if timestamp_elem then
    -- The author specified page timestamp by hand, we should use it
    timestamp = HTML.inner_html(timestamp_elem)

    -- Delete the original manual timestamp element,
    -- since it will be replaced by a formatted message
    HTML.delete_element(timestamp_elem)
  else
    timestamp = nil
  end
end

if not timestamp then
  git_command = format("git log -n 1 --pretty=format:%%ad --date=%s -- %s", git_date_format, page_file)
  timestamp = Sys.get_program_output(git_command)
end

if not timestamp then
  -- If Sys.get_program_output gave us nothing, then either the page is not in git
  -- or it failed to execute git, either way we have nothing to work with
  Log.warning(format("Failed to find page %s in git history or find a manual timestamp in it, ignoring", page_file))
  Plugin.exit()
end

timestamp_message = format(timestamp_format, timestamp)
message_elem = HTML.parse(timestamp_message)

timestamp_container = HTML.select_one(page, timestamp_container_selector)
HTML.append_child(timestamp_container, message_elem)

