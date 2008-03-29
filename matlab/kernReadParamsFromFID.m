function kern = kernReadParamsFromFID(kern, FID)

% KERNREADPARAMSFROMFID Read the kernel parameters from C++ file FID.
% FORMAT
% DESC reads kernel parameters from a file written by C++.
% ARG kern : the kernel to put the parameters in.
% ARG FID : the stream from which parameters are read.
% RETURN kern : the kernel with the parameters added.
%
% COPYRIGHT : Neil D. Lawrence, 2005, 2006, 2008
%
% SEEALSO : kernReadFromFID, modelReadFromFID

% KERN

if strcmp(kern.type, 'cmpnd') || strcmp(kern.type, 'tensor')
  kern = componentKernReadParamsFromFID(kern, FID);
else
  
  kern.inputDimension = readIntFromFID(FID, 'inputDim');
  numParams = readIntFromFID(FID, 'numParams');
  if strcmp(kern.type, 'poly') | strcmp(kern.type, 'polyard')
    kern.degree = readIntFromFID(FID, 'degree');
  end
  
  params = modelReadFromFID(FID);
  fhandle = str2func([kern.type 'KernExpandParam']);
  kern = fhandle(kern, params);
  
  numPriors = readIntFromFID(FID, 'numPriors');
  for j=1:numPriors
    ind = readIntFromFID(FID, 'priorIndex');
    prior = priorReadFromFID(FID);
    prior.index = ind+1;
    kern.priors(j) = prior;
  end
end

