/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.6

QtObject {
   property string instruction: qsTr("Districts of Canada")
   property var levels: [
      {
         "pixmapfile" : "canada/background.png",
         "type" : "SHAPE_BACKGROUND_IMAGE"
      },
      {
         "pixmapfile" : "canada/yukon.png",
         "toolTipText" : "Yukon",
         "x" : "0.074",
         "y" : "0.372"
      },
      {
         "pixmapfile" : "canada/british_columbia.png",
         "toolTipText" : "British Columbia",
         "x" : "0.083",
         "y" : "0.597"
      },
      {
         "pixmapfile" : "canada/northwest_territories.png",
         "toolTipText" : "Northwest Territories",
         "x" : "0.243",
         "y" : "0.365"
      },
      {
         "pixmapfile" : "canada/nunavut.png",
         "toolTipText" : "Nunavut",
         "x" : "0.469",
         "y" : "0.306"
      },
      {
         "pixmapfile" : "canada/alberta.png",
         "toolTipText" : "Alberta",
         "x" : "0.204",
         "y" : "0.661"
      },
      {
         "pixmapfile" : "canada/saskatchewan.png",
         "toolTipText" : "Saskatchewan",
         "x" : "0.291",
         "y" : "0.688"
      },
      {
         "pixmapfile" : "canada/manitoba.png",
         "toolTipText" : "Manitoba",
         "x" : "0.417",
         "y" : "0.698"
      },
      {
         "pixmapfile" : "canada/ontario.png",
         "toolTipText" : "Ontario",
         "x" : "0.582",
         "y" : "0.805"
      },
      {
         "pixmapfile" : "canada/quebec.png",
         "toolTipText" : "Quebec",
         "x" : "0.742",
         "y" : "0.673"
      },
      {
         "pixmapfile" : "canada/newfoundland_labrador.png",
         "toolTipText" : "Newfoundland and Labrador",
         "x" : "0.87",
         "y" : "0.603"
      },
      {
         "pixmapfile" : "canada/new_brunswick.png",
         "toolTipText" : "New Brunswick",
         "x" : "0.834",
         "y" : "0.779"
      },
      {
         "pixmapfile" : "canada/nova_scotia.png",
         "toolTipText" : "Nova Scotia",
         "x" : "0.894",
         "y" : "0.782"
      },
      {
         "pixmapfile" : "canada/prince_edward_island.png",
         "toolTipText" : "Prince Edward Island",
         "x" : "0.878",
         "y" : "0.757"
      }
   ]
}
