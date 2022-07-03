/* Below are some basic queries against a sample db of UK Accidents

Tables:

	Accident: It contains information related to the location of each accident, the number of casualties that occurred, temporal data, and weather conditions on the day of the accident.
	Vehicle: It has all the necessary information about the vehicle and its driver involved in the accident.
	Vehicle_Type: It contains more information about the vehicle involved in an accident.

*/

/* Average Severity and Total Accidents involving any type of motorcyle */

SELECT vt.label AS 'Vehicle Type', ROUND(AVG(a.Accident_Severity),2) AS 'Average Severity', COUNT(vt.code) AS 'Number of Accidents'
FROM accidents a
JOIN vechicle v ON a.Accident_Index = v.Accident_Index
JOIN vehicletype vt ON v.Vehicle_Type = vt.code
WHERE vt.label LIKE '%otorcycle%'
GROUP BY vt.label;

/*Accident Severity and Total Accidents per Vehicle Type */

SELECT vt.label AS 'Vehicle Type',a.Accident_Severity as 'Severity', COUNT(vt.label) AS 'Number of Accidents'
FROM accidents a
JOIN vechicle v ON a.Accident_Index = v.Accident_Index
JOIN vehicletype vt ON v.Vehicle_Type = vt.code
GROUP BY vt.label, a.Accident_Severity
ORDER BY 2,3;

/* Average Severity by vehicle type */

SELECT vt.label AS 'Vehicle Type',round(AVG(a.Accident_Severity),2) as 'Severity'
FROM accidents a
JOIN vechicle v ON a.Accident_Index = v.Accident_Index
JOIN vehicletype vt ON v.Vehicle_Type = vt.code
GROUP BY vt.label
ORDER BY 1,2;

