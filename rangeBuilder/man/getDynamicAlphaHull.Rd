\name{getDynamicAlphaHull}
\alias{getDynamicAlphaHull}
\title{
Generate polygon based on alpha hulls
}
\description{
Generates an apha hull polygon, where the alpha parameter is determined by the spatial
distribution of the coordinates. 
}
\usage{
getDynamicAlphaHull(x, fraction = 0.95, partCount = 3, buff = 10000, 
initialAlpha = 3, coordHeaders = c('Longitude', 'Latitude'), 
clipToCoast = TRUE, proj = "+proj=longlat +datum=WGS84", 
alphaIncrement = 1, verbose = FALSE)
}
\arguments{
	\item{x}{
		dataframe of coordinates in decimal degrees, with a minimum of 3 rows. 
	}
	\item{fraction}{
		the minimum fraction of occurrences that must be included in polygon.
	}
	\item{partCount}{
		the maximum number of disjunct polygons that are allowed.
	}
	\item{buff}{
		buffering distance in meters
	}
	\item{initialAlpha}{
		the starting value for alpha
	}
	\item{coordHeaders}{
		the column names for the longitude and latitude columns, respectively.
		If x has two columns, these are assumed to be longitude and latitude, and 
		\code{coordHeaders} is ignored.
	}
	\item{clipToCoast}{
		logical: if \code{TRUE}, then the resulting polygon is clipped to the 
		coastline. See Details.
	}
	\item{proj}{
		the projection information for x. The default is currently the only 
		supported option. 
	}
	\item{alphaIncrement}{
		the amount to increase alpha with each iteration
	}
	\item{verbose}{
		prints the alpha value to the console, intended for debugging.
	}
}

\details{

	From a set of coordinates, this function will create an alpha hull with 
	\code{alpha = initialAlpha}, and will then increase \code{alpha} by 
	\code{alphaIncrement} until both the \code{fraction} and \code{partCount} 
	conditions are met. 

	If the conditions cannot be satisfied, then a minimum convex hull is returned. 

	If \code{clipToCoast = TRUE}, the resulting polygon is clipped to the coastline, 
	using the \code{\link{gshhs}} dataset provided with this package. 
}

\value{
	a list with 2 elements:
	\item{hull}{
		a SpatialPolygons object
	}
	\item{alpha}{
		the alpha value that was found to satisfy the criteria. 
		If a convex hull was returned, this will list MCH.
	}
}
\author{
	Pascal Title
}
\seealso{
	Alpha hulls are created with \code{\link{ahull}}. 
}
\examples{
data(crotalus)

# create a polygon range for Crotalus atrox
x <- crotalus[which(crotalus$genSp == 'Crotalus_atrox'),]
x <- x[sample(1:nrow(x), 50),]

range <- getDynamicAlphaHull(x, coordHeaders=c('decimallongitude','decimallatitude'), 
	clipToCoast = FALSE)

plot(range[[1]], col=transparentColor('dark green', 0.5), border = NA)
points(x[,c('decimallongitude','decimallatitude')], cex = 0.5, pch = 3)

# to add a basic coastline
# plot(gshhs, add = TRUE)

}
 

