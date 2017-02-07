function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%          
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%


% Part 1
z2 = [ones(m, 1) X] * Theta1';
a2 = sigmoid(z2);
z3 = [ones(m, 1) a2] * Theta2';
a3 = sigmoid(z3);

for j = 1:m
  
  hj = a3(j,:)' ;
  yj = zeros(num_labels, 1);
  yj( y(j) ) = 1;
  
  yjc = ones(num_labels, 1) - yj;
  hjc = ones(num_labels, 1) - hj;

  J = J - (yj' * log(hj)) - (yjc' * log(hjc));
  
endfor;

J = J / m;

% Regularization of the cost
J = J  + (lambda / (2*m)) * ( sumsq(Theta1(:,2:end)(:)) + sumsq(Theta2(:,2:end)(:)) ); 


% Part 2

D1 = zeros(size(Theta1));
D2 = zeros(size(Theta2));

for j = 1:m

  % I
  a3j = a3(j,:)' ;
   
  % II 
  yk = zeros(num_labels, 1);
  yk( y(j) ) = 1;
  
  d3 = a3j - yk;
  
  % III
  
  z2j = z2(j,:)' ;
  d2 = ( Theta2(:,2:end)' * d3 ) .* sigmoidGradient( z2j );
  
  %(:,2:end)
  
  % IV
  a1j = X(j,:)' ;
  a2j = a2(j,:)' ;
  
%  size(d2)
%  size(a1j)
%  size(D1)
  
  D1 = D1 + d2 * [1; a1j]';
  D2 = D2 + d3 * [1; a2j]';
  
endfor;

% V
%D2 = D2(2:end);

Theta1_grad = D1 ./ m;
Theta2_grad = D2 ./ m;


% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
