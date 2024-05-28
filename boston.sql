--dataset of many different airbnb listings across Boston,MA as of March 2024

--id: This is a unique identification number for each Airbnb listing.
--name: The name of the listing, usually a descriptive title given by the host.
--host_id: A unique identification number for each host on Airbnb.
--host_name: The name of the host who owns the listing.
--neighbourhood_group: A categorical feature that may represent a larger area or district containing multiple neighborhoods.
--neighbourhood: The specific neighborhood where the listing is located.
--latitude: The geographical latitude coordinate of the listing's location.
--longitude: The geographical longitude coordinate of the listing's location.
--room_type: The type of room available for rent, such as 'Entire home/apt', 'Private room', or 'Shared room'.
--price: The price per night to rent the listing.
--minimum_nights: The minimum number of nights a guest is required to book.
--number_of_reviews: The total number of reviews the listing has received.
--last_review: The date of the last review for the listing.
--reviews_per_month: The average number of reviews the listing receives per month.
--calculated_host_listings_count: The total number of listings the host has across all of their properties.
--availability_365: The number of days the listing is available for booking within a year.
--number_of_reviews_ltm: The total number of reviews the listing has received in the last twelve months.
--license: Information regarding any licenses related to the listing (this could be a permit number or license information related to renting the property). 

select *
from airbnb

--deleting several columns as they are not useful to the analysis

alter table airbnb
drop column name, neighbourhood_group, last_review, calculated_host_listings_count, license

--each listing is unique, 4,261 listings

select distinct id
from airbnb

--count of listings per neighbourhood

select neighbourhood, count(*) as total_listings
from airbnb
group by neighbourhood
order by total_listings desc

--count of listings per room_type

select room_type, count(*) as total_listings
from airbnb
group by room_type
order by total_listings desc

--EDA

--max/min/avg prices per neighbourhood

select neighbourhood, max(price) as max_price
from airbnb
group by neighbourhood
order by max_price desc

select neighbourhood, min(price) as min_price
from airbnb
group by neighbourhood
order by min_price desc

select neighbourhood, round(avg(price), 2) as avg_price
from airbnb
group by neighbourhood
order by avg_price desc

--max/min/avg prices per room_type

select room_type, max(price) as max_price
from airbnb
group by room_type
order by max_price desc

select room_type, min(price) as min_price
from airbnb
group by room_type
order by min_price desc

select room_type, round(avg(price), 2) as avg_price
from airbnb
group by room_type
order by avg_price desc

--ranking each listing based on minimum nights required per neighbourhood, room_type, minimum_nights ordered by price

select neighbourhood, room_type, minimum_nights, price, 
dense_rank() over (partition by neighbourhood, room_type, minimum_nights order by minimum_nights asc, price asc) as minimum_nights_ranking
from airbnb
where price is not null
order by neighbourhood

--ranking each listing based on number of reviews per neighbourhood and room_type, more reviews equates a more reliable listing

select neighbourhood, room_type, number_of_reviews, price, 
dense_rank() over (partition by neighbourhood, room_type order by number_of_reviews desc, price asc) as total_reviews_ranking
from airbnb
where price is not null
order by neighbourhood

--ranking each listing based on reviews per month per neighbourhood and room_type

select neighbourhood, room_type, reviews_per_month, price, 
dense_rank() over (partition by neighbourhood, room_type order by reviews_per_month desc, price asc) as reviews_per_month_ranking
from airbnb
where price is not null
order by neighbourhood

select *
from airbnb

