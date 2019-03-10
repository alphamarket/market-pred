close all; clc;
periods = [1, 3, 7, 28, 56, 112, 224];
dataset = load_dataset();
gainset = preprocess_dataset(dataset);
trainset = create_trainset(gainset, periods);
train_module = train_dataset(trainset, periods);
aggregator = train_aggregator(trainset, train_module);