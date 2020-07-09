/* GCompris - Data.qml
 *
 * Copyright (C) 2020 Shubham Mishra <email.shivam828787@gmail.com>
 *
 * Authors:
 *   Shubham Mishra <email.shivam828787@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

Data {
    objective: qsTr("Countries of Asia.")
    difficulty: 6
    data: [
        [
            //India
            "qrc:/gcompris/src/activities/geo-country/resource/board/board12_0.qml"
        ],
        [
            //Turkey
            "qrc:/gcompris/src/activities/geo-country/resource/board/board5_0.qml",
            "qrc:/gcompris/src/activities/geo-country/resource/board/board5_1.qml",
            "qrc:/gcompris/src/activities/geo-country/resource/board/board5_2.qml"
        ],
        [
            //China
            "qrc:/gcompris/src/activities/geo-country/resource/board/board14_0.qml"
        ]
    ]
}