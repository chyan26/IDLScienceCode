FUNCTION CIRCLE, xcenter, ycenter, radius
   points = (2 * !PI / 999.0) * FINDGEN(1000)
   x = xcenter + radius * COS(points )
   y = ycenter + radius * SIN(points )
   RETURN, TRANSPOSE([[x],[y]])
END

