---
title: "An Overview of the MFA package"
author:
output: 
  rmarkdown::html_vignette:
    toc: true # table of content true
    depth: 4  # upto three depths of headings (specified by #, ## and ###)
vignette: >
  %\VignetteIndexEntry{MFA}
  %\VignetteEngine{knitr::rmarkdown}
  \usepackage[utf8]{inputenc}
---
\fontsize{12}{12}

This vignette gives an introduction to the model Multiple Factor Analysis and an overview the package MFA developed to apply the model on data. You might find reading this entire vignette helpful to get a broad understanding of what can be done in R using the MFA. 

## 1 Introdution to Multiple Factor Analysis {#sec:line-type-spec}

### 1.1 Overview

Multiple factor analysis (MFA, also called multiple factorial analysis) is an generalization of principal component analysis (PCA). Its goal is to analyze several data sets of variables collected on the same set of observations, or—as in its dual version—several sets of observations measured on the same set of variables. 

The goals of MFA are (1) to analyze several data sets measured on the same observations; (2) to provide a set of common factor scores (often called ‘compromise factor scores’); and (3) to project each of the original data sets onto the compromise to analyze communalities and discrepancies. 

### 1.2 When to use

MFA is used when several sets of variables have been measured on the same set of observations. The number and/or nature of the variables used to describe the observations can vary from one set of variables to the other, but the observations should be the same in all the data sets.

For example, suppose we have 12 wines evaluated by 10 different wine experts. The different data sets can have the same observations (wines) evaluated by different subjects (wine experts) or groups of sub- jects with different variables (each wine expert evaluates the wines with his/her own set of scales). In this case, the first data set corresponds to the first subject, the second one to the second subject and so on. The goal of the analysis, then, is to evaluate if there is an agreement between the subjects or groups of subjects.


### 1.3 Main Idea 

The general idea behind MFA is to normalize each of the individual data sets so that their first principal component has the same length. There are several terms with regards to MFA: 

* **compromise/consensus**: Obtained by combining normalized individual data table into a common representation of the observations.

* **factor scores**: The coordinates of the observations on the components. These can be used to plot maps of the ob- servations. 

* **partial factor scores**: The positions of the observations ‘as seen by’ each data set. These can be also represented as points in the compromise map. 

* **loading**: The quantity that variables contributes a certain amount to each component. This reflects the importance of that variable for this component and can also be used to plot maps of the variables that reflect their association. 

* **contributions**: A variation over squared loadings. These evaluate the importance of each variable as the pro- portion of the explained variance of the component by the variable. The contribution of a data table to a component can be obtained by adding the contributions of its variables. These contributions can then be used to draw plots expressing the importance of the data tables in the common solution.

## 2 The mathematics behind the package 

This section elaborates mathematical methods related to the model that are used in the development of MFA package.

### SVD

Recall that the $SVD$ of a given $I × J$ matrix $\textbf{Z}$ decomposes it into three matrices as:
$$\begin{equation}
\textbf{X} = \textbf{U} \Gamma \textbf{V}^T\quad \text{with} \quad  \textbf{U}^T\textbf{U} = \textbf{V}^T\textbf{V} = \textbf{I}.
\end{equation}$$
This is closely related to and generalizes the well-known $eigendecomposition$ as $\textbf{U}$ is also the matrix of the normalized eigenvectors of $\textbf{X} \textbf{X}^T$, $\textbf{V}$ is the matrix of the normalized eigenvectors of $\textbf{X}^T \textbf{X}$.
Notice that  $\textbf{X} \textbf{X}^T$ is denoted as $\textbf{S}$, which called cross product matrix of $\textbf{X}$. Therefore, if we do $eigendecomposition$ for $\textbf{S}$, we can get eigenvalue $\boldsymbol{\Lambda}$(i.e. $\Gamma^2$) and eigenvector $\textbf{U}$ (i.e. the left singular vector of $\textbf{X}$)  

*Key property*: the $SVD$ provides the best reconstitution (in a least squares sense) of the original matrix by a matrix with a lower rank.

### GSVD

The $GSVD$ generalizes the $SVD$ of a matrix by incorporating two additional positive definite matrices that represent ‘constraints’ to be incorporated in the decomposition. We call these two matrices *Mass Matrix* $\textbf{M}$ representing the ‘constraints’ imposed on the rows of an $I$ by $J$ matrix $\textbf{X}$ and *Weight Matrix* $\textbf{A}$ representing the ‘constraints’ imposed on the columns of $\textbf{X}$. Matrix $\textbf{M}$ is almost always a diagonal matrix of the ‘masses’ of the observations (i.e., the rows); whereas matrix $\textbf{A}$ implements a metric on the variables and if often but not always diagonal.Obviously, when $\textbf{M} = \textbf{A} = \textbf{I}$, the $GSVD$ reduces to the plain $SVD$.The $GSVD$ of $\textbf{X}$, taking into account $\textbf{M}$ and $\textbf{A}$, is expressed as 
$$\begin{equation}
\textbf{X}=\textbf{P}\boldsymbol{\Delta}\textbf{Q}^T \quad \text{with} \quad \textbf{P}^T\textbf{M}\textbf{P} = \textbf{Q}^T\textbf{A}\textbf{Q} = \textbf{I}.
\end{equation}$$
where $\textbf{P}$ is the $I$ by $L$ matrix of the normalized left generalized singular vectors (with $L$ being the rank of $\textbf{X}$), $\textbf{Q}$ the $J$ by $L$ matrix of the normalized generalized right singular vectors, and $\boldsymbol{\Delta}$ the $L$ by $L$ diagonal matrix of the $L$ generalized singular values.  

*Key property*: the $GSVD$ provides the best reconstitution (in a least squares sense) of the original matrix by a matrix with a lower rank under the constraints imposed by two positive definite matrices. The generalized singular vectors are orthonormal with respect to their respective matrix of constraints.  


### 2.1 DATA Preprocesing

* Centering and Scaling：It's always desirable to preprocess data before any data analysis process by first centering and normalizing each column such that its mean is equal to 0 and the sum of the square values of all its elements is equal to 1. 

* Concatenating data tables：The raw data consist of $K$ data sets collected on the same observations. Each data set is also called a table, a sub-table, or a block. The data for each table are stored in an $I × J_{[k]}$ rectangular data matrix denoted by $\textbf{Y}_{[k]}$, where $I$ is the number of observations and $J_{[k]}$ the number of variables collected on the observations for the $k$-th table. The total number of variables is denoted by $J$ (i.e., $J = \sum  J_{[k]}$). Then use `scale` function to normalize the data. 
The $K$ data matrices $\textbf{X}_{[k]}$ are concatenated into the complete $I$ by $J$ data matrix denoted by $\textbf{X}$:
$$\begin{equation}
\textbf{X}=[\textbf{X}_{[1]}|...|\textbf{X}_{[k]}|...|\textbf{X}_{[K]}].
\end{equation}$$

### 2.2 Mass Matrix

A mass, denoted by $m_i$, is assigned to each observation. These masses are collected in the mass vector, denoted by $\textbf{m}$, and in the diagonal elements of the mass matrix denoted by $\textbf{M}$, which is obtained as 
$$\begin{equation}
\textbf{M}=\text{diag}\{\textbf{m}\}
\end{equation}$$


### 2.3 Weight Matrix 

The weight matrix gathered by doing standard $PCA$ of each Data Table. Specifically, each table is expressed via its $SVD$ as
$$\begin{equation}
\textbf{X}_{[k]} = \textbf{U}_{[k]} \Gamma_{[k]}\textbf{V}^T_{[k]}\quad \text{with} \quad  \textbf{U}^T_{[k]}\textbf{U}_{[k]} = \textbf{V}^T_{[k]}\textbf{V}_{[k]} = \textbf{I}.
\end{equation}$$
In MFA, the weight of a table is obtained from the first singular value of its $PCA$. This weight, denoted by $\alpha_k$, is equal to the inverse of the first squared singular value:
$$\begin{equation}
\alpha_k=\frac{1}{\gamma_{1,k}^2}=\gamma_{1,k}^{-2}.
\end{equation}$$
For convenience, gather $\alpha$ weights in a $J$ by $1$ vector. Specifically, $\textbf{a}$ is constructed as:
$$\begin{equation}
\textbf{a}=[\alpha_1\textbf{1}_{[1]}^T,...,\alpha_k\textbf{1}_{[k]}^T,...,\alpha_K\textbf{1}_{[K]}^T],
\end{equation}$$
where $\alpha_k$ stands for the inverse of the first squared singular value of $k$-th block and $\textbf{1}_{[k]}$ for a $J_{[k]}$ vector of ones. Alternatively, the weights can be stored as the diagonal elements of a diagonal matrix denoted by $\textbf{A}$ obtained as
$$\begin{equation}
\textbf{A}=\textbf{diag}\{\textbf{a}\}.
\end{equation}$$

### 2.4 Calculating Cross-Product Matrices

After the weights have been collected, they are used to compute the $GSVD$ of $\textbf{X}$ under the constraints provided by $\textbf{M}$ and $\textbf{A}$.
In this $MFA$ package, we choose to use the cross-product matrices $\textbf{S}_{[k]}$ to compute all elements of $MFA$. The cross-product matrices can be directly computed from $\textbf{X}$ as 
$$\begin{equation}
\textbf{S}_{[+]}=\textbf{X}\textbf{A}\textbf{X}^{\textbf{T}}.
\end{equation}$$

### 2.5 Obtain eiganvalues and loadings{#anchor}

Once we got the cross product matrices, we can do *eigendecomposition* to get eigenvector and eigenvalue of $\textbf{S}_{[+]}$, denote as $\textbf{U}$ and $\boldsymbol{\lambda}$ respectively. Actually,
$$\begin{equation}
\textbf{S}_{[+]}=\textbf{U}\boldsymbol{\lambda}\textbf{U}^T=\textbf{P}\sqrt{\textbf{M}}\boldsymbol{\lambda} \sqrt{\textbf{M}}^T\textbf{P}^T=\textbf{P}\boldsymbol{\Lambda}\textbf{P}^T
\end{equation}$$

Thus, the generalized *eigendecomposition* under the constraints provided by matrix $\textbf{M}$ of the compromise gives: 
$$\begin{equation}
\textbf{S}_{[+]}=\textbf{P}\Lambda \textbf{P}^{\textbf{T}} \quad \text{with} \quad \textbf{P}^{\textbf{T}} \textbf{M}\textbf{P}=\textbf{I}.
\end{equation}$$
Then we can compute eigenvalues $\boldsymbol{\Lambda}$, left generalized singular vectors $\textbf{P}$ and right generalized singular vectors $\textbf{Q}$ given by:

$$\begin{equation}
\boldsymbol{\Lambda}=\sqrt{\textbf{M}}\boldsymbol{\lambda} \sqrt{\textbf{M}}^T
\end{equation}$$
$$\begin{equation}
\textbf{P}=\textbf{U}\sqrt{\textbf{M}}^{-1}
\end{equation}$$

$$\begin{equation}
\textbf{Q}=\textbf{X}^\textbf{T}\textbf{M}\textbf{P}\sqrt{\boldsymbol{\Lambda}}^{-1}
\end{equation}$$
where $\boldsymbol{\lambda}$ and $\textbf{U}$ is the eigenvalue and eigenvector calculated by `eigen` function on $\textbf{S}_{[+]}$. 


### 2.6 Compromise Factor Scores and Partial Factor Scores

Once we got eigenvalue $\boldsymbol{\Lambda}$, left generalized singular vectors $\textbf{P}$ and right generalized singular vectors $\textbf{Q}$, we can compute partial factor score $\textbf{F}_{[k]}$ and common factor score $\textbf{F}$ obtained from:
$$\begin{equation}
\textbf{F}_{[k]}=K\alpha_k\textbf{X}_{[k]}\textbf{Q}_{[k]}=K\alpha_k\textbf{X}_{[k]}\textbf{X}_{[k]}^T\textbf{M}\textbf{P}\boldsymbol{\Delta}^{-1}
\end{equation}$$
$$\begin{equation}
\textbf{F}=\frac{1}{K}\sum_k \textbf{F}_{[k]}
\end{equation}$$

### 2.7 Contributions

In this part, we calculate three kind of contributions: contribution of an observation to a dimension,contributions of a variable to a dimension and contribution of a table to a dimension.

#### 2.7.1 Contributions of Observation{#anchor1}

Formally, the contribution of observation $i$ to component $l$, denoted $ctr_{i,l}$, is computed as 
$$\begin{equation}
ctr_{i,l}=\frac{m_i × f_{i,l}^2}{\lambda_l} \quad \text{with} \quad \lambda_l=\sum_i m_i × f_{i,l}^2
\end{equation}$$
where $m_i$ and $f_{i,l}$ are, respectively, the mass of the $i$th observation and the factor score of the $i$th observation for the $l$th dimension.   

#### 2.7.2 Contributions of Variables{#anchor2}

As we did for the observations, we can find the important variables for a given dimension by computing variable contributions.The contribution of variable $j$ to component $l$, denoted $ctr_{j,l}$, is computed as
$$\begin{equation}
ctr_{j,l}=a_j × q_{j,l}^2 \quad \text{with} \quad 1=\sum_j a_j × q_{j,l}^2
\end{equation}$$
where $q_{i,l}$ is the loading of the $j$th variable for the $l$th dimension.  

#### 2.7.3 Contributions of Table{#anchor3}

As a table comprises several variables, the contribution of a table can simply be defined as the sum of the contributions of its variables. So the contribution of table k to component l is denoted $ctr_{k,l}$ and is defined as 
$$\begin{equation}
ctr_{k,l}=\sum_j^{J_{[k]}} ctr_{j,l}
\end{equation}$$
Contributions take values between 0 and 1, and for a given component, the contributions of all variables sum to 1. The larger a contribution of a *observation/variable/table* to a component the more this *observation/variable/table* contributes to this component. 
Table contributions and partial inertias can be used to create plots that show the importance of these tables for the components. These plots can be drawn one component at a time or two (or rarely three) components at a time in a manner analogous to factor maps.

### 2.8 $R_v$ Coefficient and $L_g$ Coefficient{#anchor_co}

To evaluate the similarity between two tables one can compute coefficients of similarity between data tables. There are two kind of coefficients in our $MFA$ package: $R_v$ coefficient reflecting the amount of variance shared by two matrices and $L_g$ coefficient reflecting the MFA normalization and taking positive values.  Specifically, $R_V$  coefficient between data tables $k$ and $k′$ is computed as

$$\begin{equation}
R_{Vk,k'}=\frac{\text{trace}\{(\textbf{X}_{[k]}\textbf{X}_{[k]}^T)× (\textbf{X}_{[k']}\textbf{X}_{[k']}^T)\}}{\sqrt{\text{trace}\{(\textbf{X}_{[k]}\textbf{X}_{[k]}^T)× (\textbf{X}_{[k]}\textbf{X}_{[k]}^T)\}× \text{trace}\{(\textbf{X}_{[k']}\textbf{X}_{[k']}^T)× (\textbf{X}_{[k']}\textbf{X}_{[k']}^T)\}}}
\end{equation}$$
$L_g$  coefficient between data tables $k$ and $k′$ is computed as
$$\begin{equation}
\begin{aligned}
L_{g(k,k')}&=\frac{\text{trace}\{(\textbf{X}_{[k]}\textbf{X}_{[k]}^T)× (\textbf{X}_{[k']}\textbf{X}_{[k']}^T)\}}{\gamma_{1,k}^2 × \gamma_{1,k'}^2}\\
&= \text{trace}\{(\textbf{X}_{[k]}\textbf{X}_{[k]}^T)× (\textbf{X}_{[k']}\textbf{X}_{[k']}^T)\}× \alpha_k × \alpha_{k'}
\end{aligned}
\end{equation}$$


### 2.9 Bootstrap for Factor Scores{#anchor_bs}

The bootstrap is using to estimate the stability of the compromise factor scores. The main idea is to
use the properties that the compromise factor scores are the average of the partial factor scores. Therefore, we can obtain bootstrap confidence intervals (CIs) by repeatedly sampling with replacement from the set of tables and compute new compromise factor scores. From these estimates we can also compute **bootstrap ratios** for each dimension by dividing the mean of the bootstrap estimates by their standard deviation.  
To compute a bootstrap estimate, first we need to generate a bootstrap sample. To do so, we take a sample of integers with replacement from the set of integers from 1 to $K$. We call this set $\mathbb{B}$ (for bootstrap). Then generate a new data set (i.e., a new $\textbf{X}$ matrix comprising $K$ tables) using matrices $\textbf{X}_{[k]}$ with these indices. Combine all these sample blocks in a data matrix denoted $\textbf{X}_1^*$ that would then be analyzed by $MFA$. This would provide a set of bootstrapped factor scores (denoted $\textbf{F}_1^*$). Then repeat the procedure a large number of times (e.g., $L$ = 1000) and generate $L$ bootstrapped matrices of factor scores $\textbf{F}_l^*$ . $\bar{\textbf{F}}^∗$ denotes the bootstrap estimated factor scores, and is computed as
$$\begin{equation}
\bar{\textbf{F}}^∗=\frac{1}{L}\sum_l^L \textbf{F}_l^*
\end{equation}$$
$\hat\sigma_{F^*}^2$ denotes the bootstrapped estimate of the variance and is computed as
$$\begin{equation}
\hat\sigma_{F^*}^2=\frac{1}{L}\big(\sum_l^L(\textbf{F}_l^*-\bar{\textbf{F}}^∗) ◦ (\textbf{F}_l^*-\bar{\textbf{F}}^∗)\big)
\end{equation}$$
**Bootstrap ratios** is computed as
$$\begin{equation}
\frac{\bar{\textbf{F}}^∗}{\hat\sigma_{F^*}}
\end{equation}$$


## 3 Step by step tutorial

We are using a data example included in the package MFA to illustrate the use of the MFA package step by step. This data example concerns 12 wines from three
wine regions and 10 expert assessors
were asked to evaluate these wines on 9-point rating
scales, using four standard variables plus extra variables if any aseessor feels necessary. We call the variables used by one assessor as one group or one table. 

### 3.1 Getting started

To run any of the MFA functions, it is necessary to make the package active by using the library command:

```r
library(MFA)
```

#### Prepare the input data

The data on which we apply MFA functions should be either data frame or matrix object in R. The users could of course read data from a local file and here are of course many ways to enter data into R, just make sure prepare the data to be analyzed as data frame or matrix. The data example 'wine' has been loaded in the global environment in R when loading the MFA package, we can use head( ) to check the 'wine' data. As the data example is of many variables, we will choose the first 12 to show:

```r
head(wine)[,1:12]
#>     V1.G1 V2.G1 V3.G1 V4.G1 V5.G1 V6.G1 V1.G2 V2.G2 V3.G2 V4.G2 V7.G2 V8.G2
#> NZ1     8     6     7     4     1     6     8     6     8     3     7     5
#> NZ2     7     5     8     1     2     8     6     5     6     3     7     7
#> NZ3     6     5     6     5     3     4     6     6     6     5     8     7
#> NZ4     9     6     8     4     3     5     8     6     8     4     6     6
#> FR1     2     2     2     8     7     3     2     3     1     7     4     3
#> FR2     3     4     4     9     6     1     4     3     4     9     3     5
```

It is required that the data on which we apply MFA functions is organized in certain way that the functions could separate each group by the arrangement of the columns of the input data, as shown in the data example 'wine', the variables of each group are stacked together and one group after another, like the first 6 columns are in Group 1 and the next 6 columns are in Group2, and so on:

```r
colnames(wine)
#>  [1] "V1.G1"  "V2.G1"  "V3.G1"  "V4.G1"  "V5.G1"  "V6.G1"  "V1.G2"  "V2.G2"  "V3.G2"  "V4.G2" 
#> [11] "V7.G2"  "V8.G2"  "V1.G3"  "V2.G3"  "V3.G3"  "V4.G3"  "V9.G3"  "V10.G3" "V1.G4"  "V2.G4" 
#> [21] "V3.G4"  "V4.G4"  "V8.G4"  "V1.G5"  "V2.G5"  "V3.G5"  "V4.G5"  "V11.G5" "V12.G5" "V1.G6" 
#> [31] "V2.G6"  "V3.G6"  "V4.G6"  "V13.G6" "V1.G7"  "V2.G7"  "V3.G7"  "V4.G7"  "V1.G8"  "V2.G8" 
#> [41] "V3.G8"  "V4.G8"  "V14.G8" "V5.G8"  "V1.G9"  "V2.G9"  "V3.G9"  "V4.G9"  "V15.G9" "V1.G10"
#> [51] "V2.G10" "V3.G10" "V4.G10"
```
It's also recommended that the input data has row names and columns names for more readable outputs of the MFA functions. The reasons will be elaborated in the next sections.

### 3.2 mfa

We can now begin to use `mfa()` function to build a MFA model on data example 'wine'. The usage of `mfa()` is:

```r
mfa(data,sets,ncomps=NULL,center=TRUE,scale=TRUE)
```

#### data
`data` is a dataframe or matrix of numerical values

#### sets
`sets` can be specified with: 

*   A list of numbers indicating column indicies of each data groups: e.g., for this wine data set if we only want to analyze the first two groups, we specify `sets=list(1:6,7:12)` means columns 1 to 6 are variables of wine accessor no.1, columns 7 to 12 are variables of wine accessor no.2.

*   A list of variable names indicating column names of each data groups,you can use the first and last variable names of each group: e.g., for this wine data sets, we can use `sets=list(c("V1.G1","V6.G1"),c("V1.G2","V8.G2"))` for data group 1 and data group 2. Alternatively, you can use the full list of variable names of each group: e.g., `sets=list(c("V1.G1","V2.G1","V3.G1","V4.G1","V5.G1","V6.G1"),
c("V1.G2","V2.G2","V3.G2","V4.G2","V7.G2","V8.G2"))` for data group 1 and data group 2. 

#### ncomp
`ncomps` controls the number of components to be considered by the model. It can be specified with:

*   The default value `ncomps=NULL`: the `mfa()` will simply output results of all components. 

*   An integer smaller than the rank of the input data: e.g., for this wine data set we can spesify `ncomps=3`, which limit all the calculations in `mfa()` to the firs 3 components of the data.

#### center
`center` determines how column centering of the input data is performed. It can be specified with:

*   A logical value: the default value `center=TRUE` meaning centering is done by subtracting the column means (omitting NAs) of x from their corresponding columns. If center is FALSE, no centering is done.
*   A numeric vector of length equal to the number of columns of the input data: centerting is done by each column subtracting the corresponding value from the `center` vector. 

#### scale
`scale` determines how column scaling of the input data is performed AFTER centering. It can be specified with:

*   A logical value: the default value `scale=TRUE` means scaling is done by dividing the (centered) columns of x by their standard deviations if center is TRUE, and the root mean square otherwise. If scale is FALSE, no scaling is done.
*   A numeric vector of length equal to the number of columns of the input data: scaling is done by each column divided by the corresponding value from scale. 

Now we use the `mfa()` on the 'wine' data set, choose to output the first 7 components and center and scale the data, then store the model returned in 'mfa_wine':

```r
varlist<-list(1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49,50:53)
mfa_wine<-mfa(wine,sets=varlist,ncomps=7,center=TRUE,scale=TRUE)
```
Use `slotNames(mfa_wine)` we can see elements of 'mfa_wine' model we just created:

```r
slotNames(mfa_wine)
```
And use `@` operatior to extract elements of the 'mfa_wine' model

```r
mfa_wine@eigenvalues
#> [1] 0.77025513 0.12292544 0.09071052 0.07601535 0.05960069 0.03920317 0.03090963
```

```r
mfa_wine@common_factor_score
#>            Dim1        Dim2        Dim3         Dim4         Dim5        Dim6         Dim7
#> NZ1 -0.98020575 -0.16325474  0.02833247  0.122967423  0.138960264  0.21752965  0.220051492
#> NZ2 -0.80886515 -0.03262348 -0.16181752  0.376869178  0.201380272 -0.13572321 -0.147904830
#> NZ3 -0.76100584  0.45418702  0.00567849  0.134631905  0.061412658 -0.07115109  0.279400608
#> NZ4 -1.11498367  0.16586214  0.22362954 -0.567155437 -0.006220427 -0.30152727 -0.002219817
#> FR1  1.37275684  0.12838880 -0.12163879  0.315803256  0.228652248 -0.06585165  0.138077283
#> FR2  1.26401538  0.10813651  0.37010578 -0.087703704 -0.413438110  0.12748875  0.156705743
#> FR3  0.80828274 -0.20466790 -0.25317711  0.085518365 -0.247645688 -0.42605557 -0.046374939
#> FR4  0.92534231 -0.40775212  0.37972251 -0.264344947  0.505067639  0.03296264 -0.058573490
#> CA1 -0.66895382 -0.36852275  0.43311223  0.342059710 -0.247480544  0.07862601 -0.250187914
#> CA2  0.07316059  0.75677932  0.04550557  0.003904788 -0.043136934  0.17500807 -0.223444581
#> CA3 -0.47610885 -0.51276640 -0.40040815 -0.173699464 -0.217286089  0.16511358  0.138517707
#> CA4  0.36656519  0.07623359 -0.54904503 -0.288851074  0.039734711  0.20358008 -0.204047262
```

```r
mfa_wine@partial_factor_score[1]
#> $`Partial Score: Group 1`
#>           Dim1        Dim2        Dim3        Dim4         Dim5        Dim6        Dim7
#> NZ1 -1.0368259 -0.15543051  0.13930669  0.24679031 -0.162763828  0.41473617 -0.50825266
#> NZ2 -1.1792261 -0.59626448 -0.27220450  0.63826129  0.068102460 -0.10935585 -1.11821673
#> NZ3 -0.2127339  0.10422766  0.05948572 -0.01383920 -0.127818046  0.27770261  0.02896248
#> NZ4 -0.9464768 -0.44628625  0.11346836 -0.02629150 -0.405530500  0.04475027 -0.42114635
#> FR1  1.5464473  0.67614480  0.21655108 -0.05814535  0.664234173 -0.16269570  0.79836061
#> FR2  1.1761338  0.74698431  0.38399501 -0.43681149 -0.014315187  0.23027867  1.08017125
#> FR3  0.6982397 -0.16623147 -0.24147325 -0.19147260  0.045967239 -0.66272995  0.15390871
#> FR4  1.0064201  0.06261449  0.28406060 -0.13821939  0.597141091 -0.43842070  0.52824187
#> CA1 -0.9220679 -0.48617627  0.29920518  0.35404701 -0.142060490 -0.23915365 -0.75964692
#> CA2  0.1894547  0.93639398  0.27684909  0.26192647  0.007180118  0.61550236  0.05944834
#> CA3 -0.6427188 -0.63969999 -0.76591711 -0.29303492 -0.441542495 -0.05027781 -0.24423632
#> CA4  0.3233537 -0.03627627 -0.49332687 -0.34321063 -0.088594536  0.07966358  0.40240572
```

```r
head(mfa_wine@loadings)
#>             Dim1       Dim2       Dim3       Dim4       Dim5       Dim6       Dim7
#> V1.G1 -0.9763854 -1.0556294  0.1409415 -0.6363690 -0.2241311 -0.3823776 -0.2494188
#> V2.G1 -0.8840598  0.8231040  0.9387799  0.2925292 -1.1786254  0.5742918 -0.4998855
#> V3.G1 -0.8622316 -1.3130459 -0.2932791 -0.2806914 -0.6640330 -0.4691778 -0.1329888
#> V4.G1  0.7996938  0.6090401  1.6797490 -0.3052475  0.5165825  0.4387189  1.2649075
#> V5.G1  0.9496282 -0.5340688  0.3582355 -0.0983741 -0.1452547 -1.8152914 -0.2308747
#> V6.G1 -0.7724651 -0.4273872  0.7643973  1.5202985  1.1884692 -0.6638452 -1.5832512
```

### 3.3 print

Use `print()` on an object returned by `mfa()`, e.g. the 'mfa_wine' in this tutorial, will display the very basic information of the object.


```r
print(mfa_wine)
#> There are 7 components. 
#> The eigenvalue of the first component is:  0.7702551 
#> The eigenvalue of the second component is:  0.1229254
```

### 3.4 plot

Use `plot()` on an object returned by `mfa()`, e.g. the 'mfa_wine' in this tutorial, will display graphs with regard to the object and also save the image in high resolution in the working directory named 'mfa.jpeg'. The usage of `plot()` is:

```r
plot(x,dim,singleoutput=NULL)
```

#### `x`
`x` must be an object return by `mfa()`.

#### `dim`
`dim` determines which two dimensions the graphs will be based on. It can be specified with:

*   A vector of integers: e.g., `dim=c(1,2)` means plot the graphs on dimension 1 and dimension 2.

#### `singleoutput`
`singleoutput` determines whether to display all plots in the same graphs or display one specific single graph. It can be specified with:

*   The default value `singleoutput=NULL`: the `plot()` will display plots of eigenvalues, compromise factor scores, partial factor scores, and loadings(rescaled to have singular values ad variances) on the same graph. This graph will be saved as 'mfa.jpeg' in the working directory.

*   A charater string indicating which graph to be plotted: e.g. `singleoutput='eig'` will display a barchar of eigenvalues, `singleoutput='com'` will display a scatter plot of compromise factor scores, and `singleoutput='par'` will display scatter plots of each group's partial factor scores and loadings(rescaled to have singular values ad variances). This graph will be saved as 'mfa.jpeg' in the working directory.


```r
plot(mfa_wine,dim=c(1,2),singleoutput=NULL)
```

<img src="figure/unnamed-chunk-14-1.png" title="plot of chunk unnamed-chunk-14" alt="plot of chunk unnamed-chunk-14" width="720px" style="display: block; margin: auto;" />

```r
plot(mfa_wine,dim=c(1,2),singleoutput='eig')
```

<img src="figure/unnamed-chunk-15-1.png" title="plot of chunk unnamed-chunk-15" alt="plot of chunk unnamed-chunk-15" width="500px" style="display: block; margin: auto;" />

```r
plot(mfa_wine,dim=c(1,2),singleoutput='com')
```

<img src="figure/unnamed-chunk-16-1.png" title="plot of chunk unnamed-chunk-16" alt="plot of chunk unnamed-chunk-16" width="500px" style="display: block; margin: auto;" />

```r
plot(mfa_wine,dim=c(1,2),singleoutput='par')
```

<img src="figure/unnamed-chunk-17-1.png" title="plot of chunk unnamed-chunk-17" alt="plot of chunk unnamed-chunk-17" width="720px" style="display: block; margin: auto 0 auto auto;" />

### 3.5 eigenvalues

`eigenvalues()` is a function that takes 'mfa' object and returns a table with the singular values(i.e. square root of eigenvalues), the eigenvalues, cumulative, percentage of intertia and cumulative percentage of inertia for all the extracted components. To see detailed explanation of the eigenvalues, see [2.5 Obtain eiganvalues and loadings](#anchor)

```r
eigenvalues(mfa_wine)
#>                               1          2           3           4           5           6
#> Singular value        0.8776418  0.3506073  0.30118188  0.27570882  0.24413253  0.19799790
#> Eigenvalue            0.7702551  0.1229254  0.09071052  0.07601535  0.05960069  0.03920317
#> Cumulative            0.7702551  0.8931806  0.98389110  1.05990645  1.11950714  1.15871031
#> % Inertia            64.7480010 10.3331695  7.62516827  6.38988547  5.01006167  3.29543650
#> Cumulative % Inertia 64.7480010 75.0811704 82.70633867 89.09622415 94.10628582 97.40172232
#>                                 7
#> Singular value         0.17581135
#> Eigenvalue             0.03090963
#> Cumulative             1.18961994
#> % Inertia              2.59827768
#> Cumulative % Inertia 100.00000000
```

### 3.6 contributions

`contributions()` is a function that takes 'mfa' object and returns a list of matrix with 1). Contribution of an observation to a dimension. 2). Contribution of a variable to a dimension. 3). Contribution of a table to a dimension. These values help interpreting how observations,variables and tables contribute to the variability of the extracted dimensions. To see detailed explanations of eac contribution, see [2.7.1 Contributions of Observation](#anchor1),  [2.7.2 Contributions of Variables](#anchor2), and [2.7.3 Contributions of Table](#anchor3).

We can use `str()` to see the structure of the list return by `contributions()`. 

```r
str(contributions(mfa_wine))
#> List of 3
#>  $ observations: num [1:12, 1:7] 0.1039 0.0708 0.0627 0.1345 0.2039 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:12] "NZ1" "NZ2" "NZ3" "NZ4" ...
#>   .. ..$ : chr [1:7] "Dim1" "Dim2" "Dim3" "Dim4" ...
#>  $ variables   : num [1:53, 1:7] 0.0209 0.0171 0.0163 0.014 0.0198 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:53] "V1.G1" "V2.G1" "V3.G1" "V4.G1" ...
#>   .. ..$ : chr [1:7] "Dim1" "Dim2" "Dim3" "Dim4" ...
#>  $ table       : num [1:10, 1:7] 0.1011 0.1001 0.1011 0.0964 0.0975 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : NULL
#>   .. ..$ : chr [1:7] "Dim1" "Dim2" "Dim3" "Dim4" ...
```
Obviously the list has 3 matrices of the names 'observations','variables' and 'table', each can accessed by the operator `$`:

```r
contributions(mfa_wine)$observations
#>             Dim1        Dim2         Dim3         Dim4         Dim5        Dim6         Dim7
#> NZ1 0.1039486000 0.018067938 7.374457e-04 1.657668e-02 2.699906e-02 0.100585298 1.305490e-01
#> NZ2 0.0707842116 0.000721502 2.405538e-02 1.557036e-01 5.670238e-02 0.039156674 5.897795e-02
#> NZ3 0.0626556339 0.139844827 2.962285e-05 1.987071e-02 5.273309e-03 0.010761200 2.104649e-01
#> NZ4 0.1344996531 0.018649686 4.594301e-02 3.526319e-01 5.410132e-05 0.193263910 1.328493e-05
#> FR1 0.2038784809 0.011174582 1.359268e-02 1.093328e-01 7.310017e-02 0.009217876 5.140075e-02
#> FR2 0.1728577563 0.007927234 1.258383e-01 8.432441e-03 2.389948e-01 0.034549463 6.620561e-02
#> FR3 0.0706823155 0.028397259 5.888572e-02 8.017449e-03 8.574898e-02 0.385860277 5.798179e-03
#> FR4 0.0926379624 0.112711812 1.324628e-01 7.660542e-02 3.566700e-01 0.002309626 9.249690e-03
#> CA1 0.0484146088 0.092067334 1.723304e-01 1.282689e-01 8.563466e-02 0.013141049 1.687554e-01
#> CA2 0.0005790799 0.388253590 1.902349e-03 1.671523e-05 2.601753e-03 0.065104905 1.346061e-01
#> CA3 0.0245243020 0.178244477 1.472878e-01 3.307611e-02 6.601328e-02 0.057951295 5.172917e-02
#> CA4 0.0145373955 0.003939760 2.769345e-01 9.146721e-02 2.207535e-03 0.088098426 1.122500e-01
```

```r
contributions(mfa_wine)$table
#>             Dim1       Dim2       Dim3       Dim4       Dim5       Dim6       Dim7
#>  [1,] 0.10113269 0.09540216 0.09905229 0.06536089 0.07844541 0.10131362 0.09835963
#>  [2,] 0.10005784 0.06849423 0.12251404 0.03382958 0.10011471 0.15331652 0.04380238
#>  [3,] 0.10105112 0.15169038 0.06291732 0.19875141 0.04113903 0.10468637 0.15284169
#>  [4,] 0.09641740 0.04858138 0.07429261 0.10079654 0.07322064 0.12088025 0.18862396
#>  [5,] 0.09752272 0.06349839 0.24773464 0.26429146 0.15301178 0.21883123 0.03786737
#>  [6,] 0.10076960 0.10444939 0.02967381 0.05234504 0.17782669 0.03501623 0.12514437
#>  [7,] 0.10219421 0.22409607 0.05367775 0.13045847 0.12714459 0.06481349 0.08537581
#>  [8,] 0.09555924 0.13410088 0.16540516 0.12833199 0.10541182 0.07576557 0.21880741
#>  [9,] 0.10013993 0.05281807 0.08998547 0.00555043 0.07898804 0.10819132 0.03195108
#> [10,] 0.10515523 0.05686903 0.05474691 0.02028419 0.06469729 0.01718540 0.01722631
```
As there are quite a few variables, we use `head()` to display the first several lines: 

```r
head(contributions(mfa_wine)$variables)
#>             Dim1        Dim2         Dim3         Dim4         Dim5        Dim6         Dim7
#> V1.G1 0.02088509 0.024412753 0.0004351826 0.0088718004 0.0011005200 0.003203160 0.0013628631
#> V2.G1 0.01712210 0.014842367 0.0193072914 0.0018747020 0.0304330434 0.007225352 0.0054743792
#> V3.G1 0.01628702 0.037770575 0.0018843258 0.0017260445 0.0096599113 0.004822461 0.0003874571
#> V4.G1 0.01401010 0.008126163 0.0618133852 0.0020412582 0.0058461931 0.004216640 0.0350518802
#> V5.G1 0.01975609 0.006248678 0.0028114549 0.0002120095 0.0004622255 0.072191566 0.0011677404
#> V6.G1 0.01307229 0.004001629 0.0128006514 0.0506350796 0.0309435164 0.009654446 0.0549153081
```

### 3.7 RV and LG

`RV()` takes two groups of data and return the $R_v$ Coefficient between them. Likewise, `LG()`takes two groups of data and return the $L_g$ Coefficient between them. To see detailed explanation of these two types of coeffecients, see [2.8 $R_v$ Coefficient and $L_g$ Coefficient](#anchor_co).
The usage of `RV()` is:

```r
RV(table1,table2)
```
`talble1` and `table2` are two groups of normalized data tables each contains their own variables. e.g. for 'wine' data set, the first 6 columns belongs to Group 1 and the next 6 columns belongs to Group2, we first normalized the two tables use R's `scale()` function and then use `RV()` to compute their $R_v$ Coefficient:

```r
table1<-scale(wine[,1:6])
table2<-scale(wine[,7:12])
RV(table1,table2)
#> [1] 0.8677509
```
Similarly, `LG()` takes two normalized data tables and for the first two groups of 'wine' data set we use `LG()` to compute their $L_g$ Coefficient:

```r
table1<-scale(wine[,1:6])
table2<-scale(wine[,7:12])
LG(table1,table2)
#> [1] 0.9180402
```

### 3.8 RV_table and LG_table

`RV_table()` takes a data set and a list with sets of variables, and return a symmetric matrix of $R_v$ Coefficients, and a symmetric matrix of $L_g$ coefficients for `LG_table()`. To see detailed explanation, see [2.8 $R_v$ Coefficient and $L_g$ Coefficient](#anchor_co).
The usage of `RV_table()` is:

```r
RV_table(dataset,sets)
```
`dataset` is a normalized data set and `sets` is a list like the `sets` in `mfa()` function indicating the variables of each group. E.g. for the 'wine' data set, to compute the $R_v$ Coefficients between each pair of the first 3 data groups, we can use `RV_table()`:

```r
nor_wine<-scale(wine[,1:18])
RV_table(nor_wine,sets=list(1:6,7:12,13:18))
#>           [,1]      [,2]      [,3]
#> [1,] 1.0000000 0.8677509 0.8603765
#> [2,] 0.8677509 1.0000000 0.7755188
#> [3,] 0.8603765 0.7755188 1.0000000
```
Similarly for `LG_table()`:

```r
nor_wine<-scale(wine[,1:18])
LG_table(nor_wine,sets=list(1:6,7:12,13:18))
#>           [,1]      [,2]      [,3]
#> [1,] 1.0585802 0.9180402 0.9443864
#> [2,] 0.9180402 1.0573275 0.8507391
#> [3,] 0.9443864 0.8507391 1.1381478
```

### 3.9 bootstrap
MFA is a descriptive multivariate technique, but it is often important to be able to complement the descriptive conclusions of an analysis by assessing if its results are reliable and replicable. `bootstrap()` is a function that takes the output of `mfa()` and return the boostrap ratio (by dividing each bootstrap mean by its standard deviation) of the compromise factor scores. To see the detailed explanation of how `bootstrap()`estimates the stability of the compromise factor scores, see [2.9 Bootstrap for Factor Scores](#anchor_bs). The useage of `bootstrap()` is:

```r
bootstrap(object,nbt=1000)
```
* `object` is an object as an output of `mfa()` function like 'mfa_Wine'
* `nbt` is an integer value stands for the number of bootstrap samples with a default value of 1000.
Use `bootstrap()` on our 'mfa_wine' to get the bootstrap ratios:

```r
bootstrap(mfa_wine,nbt=10000)
#>            Dim1       Dim2        Dim3       Dim4        Dim5       Dim6         Dim7
#> NZ1 -25.3524167 -1.2835214  0.37404044  0.8288101  1.61571859  1.6807732  1.324421964
#> NZ2 -10.1327536 -0.3099367 -1.42887562  2.4419864  1.78416250 -0.9901482 -1.109920711
#> NZ3  -8.3069155  5.1944183  0.05714396  0.8999515  0.62687330 -0.4249247  1.782292733
#> NZ4 -15.9087863  1.0677955  1.87454336 -3.6163992 -0.03613001 -1.3403419 -0.004849375
#> FR1  20.5783722  1.0609786 -1.35266493  2.2217200  1.23078788 -0.2590381  0.867884137
#> FR2  15.2616428  0.9216897  1.93216566 -0.3847201 -2.43286906  0.6306047  0.664727308
#> FR3   8.4442260 -2.0752885 -2.64963185  0.9692740 -2.12571711 -3.0589885 -0.378688644
#> FR4  15.7556692 -3.6547031  2.39122778 -1.2305317  2.68154717  0.1839362 -0.307273629
#> CA1  -6.6711809 -2.5093534  5.39387065  2.6424877 -3.27565376  0.5016182 -2.506862418
#> CA2   0.9831022  5.3903731  0.53410052  0.0224269 -0.37306968  1.3616083 -3.286490055
#> CA3  -6.2214388 -6.6492194 -2.94488365 -1.4640887 -1.68833946  1.0976608  0.997348557
#> CA4   5.1276211  0.6139674 -6.75522411 -3.4684929  0.45220445  1.8950868 -2.217931384
```

# 4 Shiny App

We have created a Shiny App for visualization of the output of this package. Please see our Shiny App at [MFA Shiny App](https://zyz2012.shinyapps.io/ShinyApp/)In this part, we will give a brief introduction about how to use the shiny app to do multiple factor analysis. Users are required to give the inputs including **data**,**set**, and the **dimesions** of the outcomes which they want to plot. 

## Input
`data`: Users should choose data of **.csv** format with the header and with the first column as the id. If nothing is chosen, the shiny app will plot the outcome of the *wine.csv* as default.

`sets`: Users should choose sets of **.txt** format. The .txt file should have the sets of the format below:
$$1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:53$$
(Use "**,**" to seperate different groups, and "**:**" to separate the starting and ending columns in the data set)
If *sets* is not given, the shiny app will plot the outcome of the *sets.txt* as an example.

`dim`: Usually, **dim** equals **c(1,2)** to assign the most important two components.

##Output
`A table` shows the outcome of eigenvalues, partial factor scores, common factor scores and loadings respectively.
`Four pictures` show the outcome of eigenvalues, partial factor scores, common factor scores and loadings.

**Notes**
1.When plotting the outcome of partial factor scores, it may take some time due to the large size of the picture.

