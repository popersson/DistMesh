# DistMesh Function Reference

[Back to Home](../README.md)

---

## boundedges

**Syntax:**
```matlab
e = boundedges(p,t)

```

**Description:**
Find all the boundary edges `e` in triangular mesh `p,t`.

> **Comments:** Useful for implementation of boundary conditions for PDE solvers. See `surftri` for 3-D version.

## circumcenter

**Syntax:**

```matlab
[pc,r] = circumcenter(p,t)

```

**Description:**
Compute the circumcenters `pc` and the circumradii `r` for all triangles in the mesh `p,t`.

> **Comments:** Not vectorized.

## dcircle

**Syntax:**

```matlab
d = dcircle(p,xc,yc,r)

```

**Description:**
Compute signed distance function for circle centered at `xc,yc` with radius `r`.

## ddiff

**Syntax:**

```matlab
d = ddiff(d1,d2)

```

**Description:**
Compute signed distance function for set difference of two regions described by signed distance functions `d1,d2`.

> **Comments:** Not exactly the true signed distance function for the difference, for example around corners.

## dellipse

**Syntax:**

```matlab
d = dellipse(p,axes)

```

**Description:**
Compute distance from points `p` to the ellipse centered at the origin with `axes=[a,b]`.

> **Comments:** C++ code, uses LAPACK for eigenvalue problem.

## dellipsoid

**Syntax:**

```matlab
d = dellipsoid(p,axes)

```

**Description:**
Compute distance from points `p` to the ellipsoid centered at the origin with `axes=[a,b,c]`.

> **Comments:** C++ code, uses LAPACK for eigenvalue problem.

## dexpr

**Syntax:**

```matlab
d = dexpr(p,fin,nit,alpha)

```

**Description:**
Compute signed distance function for general implicit expression `fin`. The parameters `nit` and `alpha` have the default values 20 and 0.1.

> **Comments:** Requires the Symbolic Toolbox, although easy to rewrite to accept derivatives of `fin` as inputs. The performance is poor, a simple C implementation makes a big difference.

## dintersect

**Syntax:**

```matlab
d = dintersect(d1,d2)

```

**Description:**
Compute signed distance function for set intersection of two regions described by signed distance functions `d1,d2`.

> **Comments:** Not exactly the true signed distance function for the intersection, for example around corners.

## distmesh2d

**Syntax:**

```matlab
[p,t] = distmesh2d(fd,fh,h0,bbox,pfix,fparams)

```

**Description:**
2-D Mesh Generator. See other documentation for details on usage.

## distmeshnd

**Syntax:**

```matlab
[p,t] = distmeshnd(fd,fh,h0,bbox,pfix,fparams)

```

**Description:**
3-D Mesh Generator. See other documentation for details on usage.

## distmeshsurface

**Syntax:**

```matlab
[p,t] = distmeshsurface(fd,fh,h0,bbox,fparams)

```

**Description:**
3-D Surface Mesh Generator. See other documentation for details on usage.

## dmatrix

**Syntax:**

```matlab
d = dmatrix(p,xx,yy,dd)

```

**Description:**
Compute signed distance function by interpolation of the values `dd` on the Cartesian grid `xx,yy`.

> **Comments:** `xx,yy` can be created with `meshgrid`.

## dmatrix3d

**Syntax:**

```matlab
d = dmatrix3d(p,xx,yy,zz,dd)

```

**Description:**
Compute signed distance function by interpolation of the values `dd` on the Cartesian grid `xx,yy,zz`.

> **Comments:** `xx,yy,zz` can be created with `ndgrid`.

## dpoly

**Syntax:**

```matlab
d = dpoly(p,pv)

```

**Description:**
Compute signed distance function for polygon with vertices `pv`.

> **Comments:** Uses `dsegment` and `inpolygon`. It is usually good to provide `pv` as fix points to `distmesh2d`.

## drectangle

**Syntax:**

```matlab
d = drectangle(p,x1,x2,y1,y2)

```

**Description:**
Compute signed distance function for rectangle with corners `(x1,y1)`, `(x2,y1)`, `(x1,y2)`, `(x2,y2)`.

> **Comments:** Incorrect distance to the four corners, see `drectangle0` for a true distance function.

## drectangle0

**Syntax:**

```matlab
d = drectangle0(p,x1,x2,y1,y2)

```

**Description:**
Compute signed distance function for rectangle with corners `(x1,y1)`, `(x2,y1)`, `(x1,y2)`, `(x2,y2)`.

> **Comments:** See `drectangle` for simpler version ignoring corners.

## dsegment

**Syntax:**

```matlab
ds = dsegment(p,pv)

```

**Description:**
Compute distance from points `p` to the line segments in `pv`.

> **Comments:** C++ code, used by `dpoly`.

## dsphere

**Syntax:**

```matlab
d = dsphere(p,xc,yc,zc,r)

```

**Description:**
Compute signed distance function for sphere centered at `xc,yc,zc` with radius `r`.

## dunion

**Syntax:**

```matlab
d = dunion(d1,d2)

```

**Description:**
Compute signed distance function for set union of two regions described by signed distance functions `d1,d2`.

> **Comments:** Not exactly the true signed distance function for the union, for example around corners.

## fixmesh

**Syntax:**

```matlab
[p,t] = fixmesh(p,t)

```

**Description:**
Remove duplicated and unused nodes from `p` and update `t` correspondingly. Also make all elements orientations equal.

## hmatrix

**Syntax:**

```matlab
h = hmatrix(p,xx,yy,dd,hh)

```

**Description:**
Compute mesh size function by interpolation of the values `hh` on the Cartesian grid `xx,yy`.

> **Comments:** `xx,yy` can be created with `meshgrid`. The parameter `dd` is not used, but included to get a syntax consistent with `dmatrix`.

## hmatrix3d

**Syntax:**

```matlab
h = hmatrix3d(p,xx,yy,zz,dd,hh)

```

**Description:**
Compute mesh size function by interpolation of the values `hh` on the Cartesian grid `xx,yy,zz`.

> **Comments:** `xx,yy,zz` can be created with `ndgrid`. The parameter `dd` is not used, but included to get a syntax consistent with `dmatrix`.

## huniform

**Syntax:**

```matlab
h = huniform(p)

```

**Description:**
Implements the trivial uniform mesh size function `h=1`.

## meshdemo2d

**Syntax:**

```matlab
meshdemo2d

```

**Description:**
Demonstration of `distmesh2d`.

## meshdemond

**Syntax:**

```matlab
meshdemond

```

**Description:**
Demonstration of `distmeshnd`.

## mkt2t

**Syntax:**

```matlab
[t2t,t2n] = mkt2t(t)

```

**Description:**
Compute element connectivities from element indices.

## protate

**Syntax:**

```matlab
p = protate(p,phi)

```

**Description:**
Rotate points `p` the angle `phi` around origin.

## pshift

**Syntax:**

```matlab
p = pshift(p,x0,y0)

```

**Description:**
Move points `p` by `(x0,y0)`.

## simpplot

**Syntax:**

```matlab
simpplot(p,t,expr,bcol,icol)

```

**Description:**
Plot 2-D or 3-D mesh `p,t`. The parameters `expr`, `bcol`, `icol` are only used in 3-D and they have default values.

## simpqual

**Syntax:**

```matlab
q = simpqual(p,t,type)

```

**Description:**
Compute qualities of triangular or tetrahedral elements in the mesh `p,t`. If `type==1` (default) the inradius/outradius expression is used. If `type==2` a slightly different expression is used.

## simpvol

**Syntax:**

```matlab
v = simpvol(p,t)

```

**Description:**
Compute the signed volumes of the simplex elements in the mesh `p,t`.

## surftri

**Syntax:**

```matlab
tri = surftri(p,t)

```

**Description:**
Find all the surface triangles `tri` in tetrahedral mesh `p,t`.

> **Comments:** Used by `simpplot`. Also useful for implementation of boundary conditions for PDE solvers. See `boundedges` for 2-D version.

## uniformity

**Syntax:**

```matlab
u = uniformity(p,t,fh,fparams)

```

**Description:**
Computes "uniformity measure", that is, how close the element sizes in the mesh `p,t` are to the desired mesh size function `fh`.
