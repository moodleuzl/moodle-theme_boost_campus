<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Theme Boost Campus Login - Layout file.
 *
 * @package   theme_boost_campus
 * @copyright 2017 Kathrin Osswald, Ulm University kathrin.osswald@uni-ulm.de
 * @copyright based on code from theme_boost by Damyon Wiese
 * @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

defined('MOODLE_INTERNAL') || die();

require_once($CFG->dirroot . '/theme/boost_campus/locallib.php');

$bodyattributes = $OUTPUT->body_attributes();
$loginbackgroundimagetext = theme_boost_campus_get_loginbackgroundimage_text();

// MODIFICATION START: Set these variables in any case as it's needed in the columns2.mustache file.
$perpinfobannershowonselectedpage = false;
$timedinfobannershowonselectedpage = false;
// MODIFICATION END.

$templatecontext = [
    'sitename' => format_string($SITE->shortname, true, ['context' => context_course::instance(SITEID), "escape" => false]),
    'output' => $OUTPUT,
    'bodyattributes' => $bodyattributes,
    'loginbackgroundimagetext' => $loginbackgroundimagetext,
    'perpinfobannershowonselectedpage' => $perpinfobannershowonselectedpage,
    'timedinfobannershowonselectedpage' => $timedinfobannershowonselectedpage
];

// MODIFICATION START: Settings for information banner.
$perpetualinfobannerenable = get_config('theme_boost_campus', 'perpetualinfobannerenable');

if ($perpetualinfobannerenable) {
    $perpetualinfobannercontent = format_text(get_config('theme_boost_campus', 'perpetualinfobannercontent'), FORMAT_HTML);
    // Result of multiselect is a string divided by a comma, so exploding into an array.
    $perpetualinfobannerpagestoshow = explode(",", get_config('theme_boost_campus', 'perpetualinfobannerpagestoshow'));
    $perpetualinfobannercssclass = get_config('theme_boost_campus', 'perpetualinfobannercssclass');

    $perpinfobannershowonselectedpage = theme_boost_campus_show_banner_on_selected_page($perpetualinfobannerpagestoshow,
            $perpetualinfobannercontent, $PAGE->pagelayout, false);

    var_dump("BLA    :");
    var_dump($perpinfobannershowonselectedpage);

    // Add the variables to the templatecontext array.
    $templatecontext['perpetualinfobannercontent'] = $perpetualinfobannercontent;
    $templatecontext['perpetualinfobannercssclass'] = $perpetualinfobannercssclass;
    $templatecontext['perpinfobannershowonselectedpage'] = $perpinfobannershowonselectedpage;
}
// MODIFICATION END.

// MODIFICATION START: Settings for time controlled information banner.
$timedinfobannerenable = get_config('theme_boost_campus', 'timedinfobannerenable');

if ($timedinfobannerenable) {
    $timedinfobannercontent = format_text(get_config('theme_boost_campus', 'timedinfobannercontent'), FORMAT_HTML);
    // Result of multiselect is a string divided by a comma, so exploding into an array.
    $timedinfobannerpagestoshow = explode(",", get_config('theme_boost_campus', 'timedinfobannerpagestoshow'));
    $timedinfobannercssclass = get_config('theme_boost_campus', 'timedinfobannercssclass');
    $timedinfobannerstarttimesetting = get_config('theme_boost_campus', 'timedinfobannerstarttime');
    $timedinfobannerendtimesetting = get_config('theme_boost_campus', 'timedinfobannerendtime');
    $now = time();

    // Check if settings are empty and try to convert the string to a unix timestamp.
    if (empty($timedinfobannerstarttimesetting)) {
        $timedinfobannerstarttimeempty = true;
    } else {
        $timedinfobannerstarttime = strtotime($timedinfobannerstarttimesetting);
    }
    if (empty($timedinfobannerendtimesetting)) {
        $timedinfobannerendtimeempty = true;
    } else {
        $timedinfobannerendtime = strtotime($timedinfobannerendtimesetting);
    }

    // Add the time check:
    // Show the banner when now is between start and end time and both dates are correctly set OR
    // Show the banner when start is not set but end is not reaches yet and end date is correctly set OR
    // Show the banner when end is not set, but start lies in the past and start date is correct set OR
    // Show the banner if no dates are set, so there's no time restriction.
    if (($now >= $timedinfobannerstarttime && $now <= $timedinfobannerendtime && $timedinfobannerstarttime != false
                    && $timedinfobannerendtime != false) ||
            ($timedinfobannerstarttimeempty && $now <= $timedinfobannerendtime && $timedinfobannerendtime != false) ||
            ($now >= $timedinfobannerstarttime && $timedinfobannerendtimeempty && $timedinfobannerstarttime != false) ||
            ($timedinfobannerstarttimeempty && $timedinfobannerendtimeempty)) {
        $timedinfobannershowonselectedpage = theme_boost_campus_show_banner_on_selected_page($timedinfobannerpagestoshow,
                $timedinfobannercontent, $PAGE->pagelayout, false);
    }

    // Add the variables to the templatecontext array.
    $templatecontext['timedinfobannercontent'] = $timedinfobannercontent;
    $templatecontext['timedinfobannercssclass'] = $timedinfobannercssclass;
    $templatecontext['timedinfobannershowonselectedpage'] = $timedinfobannershowonselectedpage;
}
// MODIFICATION END.

// MODIFICATION START: Handle additional layout elements.
// The output buffer is needed to render the additional layout elements now without outputting them to the page directly.
ob_start();

// Include own layout file for the footnote region.
// The theme_boost/login template already renders the standard footer.
// The footer blocks and the image area are currently not shown on the login page.
// Here, we will add the footnote only.
// Get footnote config.
$footnote = get_config('theme_boost_campus', 'footnote');
if (!empty($footnote)) {
    // Add footnote layout file.
    require_once(__DIR__ . '/includes/footnote.php');
}

// Get output buffer.
$pagebottomelements = ob_get_clean();

// If there isn't anything in the buffer, set the additional layouts string to an empty string to avoid problems later on.
if ($pagebottomelements == false) {
    $pagebottomelements = '';
}
// Add the additional layouts to the template context.
$templatecontext['pagebottomelements'] = $pagebottomelements;

// Render own template.
echo $OUTPUT->render_from_template('theme_boost_campus/login', $templatecontext);
// MODIFICATION END.
/* ORIGINAL START.
echo $OUTPUT->render_from_template('theme_boost/login', $templatecontext);
ORIGINAL END. */
