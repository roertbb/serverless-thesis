# Ideas

- https://www.serverless.com/blog/amazon-rds-proxy
- https://www.jeremydaly.com/serverless-microservice-patterns-for-aws/?utm_source=sidebar
- Ticket to ride - based on the Appsync + direct resolvers writing to DynamoDB to persist state + subscriptions for live update - (Event sourcing) storing moves in dynamodb, aggregate on the client side + aggregate on th lambda when joining the game?
- https://awsfeed.com/whats-new/serverless/how-i-scaled-an-appsync-project-to-200-resolvers

- https://aws.amazon.com/blogs/mobile/appsync-pipeline-resolvers-3/
- https://aws.amazon.com/blogs/mobile/integrating-aws-appsync-neptune-elasticache/
- FaaS, provisioned concurrency FaaS, prewarmed FaaS by the ping, direct service access via API Gateway, lambda parameters tunning based on the computation type (memory-bound, cpu-bound)

# Microservices vs Serverless: A Performance Comparison on a Cloud-native Web Application

- microservices - agility, scalability, resiliency
- serverless - offloads management and server configuration from user to provider

- research - performance comparison in terms of: scalability, reliability, cost, latency
- shows that neither serverless, nor microservices fits all the scenarios - advantages under different scenarios
- microservices has benefits for long-lasting services over serverless
- large size response - more suitable for serverless

microservices

- monolith to microservice migration for better agility
- only teams with strong devops culture get benefits of microservice architecture
- each modules dedicated to specific business role, communicates via well defined interface
- advantages: improved fault tolerance, flexibility of using tehcnologies, scalability and speed up of the applications
- disadvantages: increased development and deployment complexity, implementing communication between services, end-to-end testing
- using containerisation deployment - higher deployemnt speed, agility and lower resource consumption

serverless

- releases the need fo managing the servers, devs can focus on development instead of infra management
- serverless cost based on number of requests and the time it takes to execute

- does not require management of the underlying infrastructure - executing, infra management, operations, autoscaling and maintenance handled by the provider
- billing per function execution and tim it requires to run it - lower cost of ownership and pay as you go model
- serverless platform accepts application code and deployment specification and uses it for further execution
- all major developers include frameworks to develop the apps in serverless env, local env for testing and debugging, gathering logs and distributed tracing based on the request id

- not only migrating from microservices, but also considering where to migrate - microservices or serverless
- (Jambunathan and Yoganathan) - architecture decissions between microservices and serverless
- serverless - infra restrictions, must be hosted by cloud providers (vendor lock-in), but auto-scaling, no infra managements, automaitc deployments are the benefit
- microservices - could be deployed on a public and private cloud - no vendor lockin, but reuqires management and handling deployment and scaling

research

- simple app similar to the Toggl - mostly crud operations, 12 API calls
- same database - AWS Aurora, contianer and lambda both 512MB RAM
- load tested using k6, saving results in InfluxDB + Grafana for visualisation
- 12 APIs _ load patterns (increasing, random, traingle) _ 2 deployment strategies

microservices

- AWS ECS, container orchestration using Docker, 5 services, autoscaling by adding 2 more instances when utilisation above 50\%, removing instances after 1 min when below 30\% of utilisation, dedicated load-balancer
- (\#1 fav projects - get large amoount of data) response time rise with the workload, but after scale-out decreased, peaking response time when starts to scale
- (\#2 timesheets - create, delete, update) better time with the delete operation??? microservices more cost effective than serverless
- (\#3 misc - simpla, small, static requests) better response time

serverless

- AWS Lambda + API Gateway
- (\#1 fav projects) for simple requests - better performance stabilit and scaling-agility, initially "cold starts", better throughput (more request/time), cheaper
- (\#2 timesheets) better performance responsiveness and stability, especially when microservices started to scale, still suffers cold start

conclusions

- serverless - starts - provisioned concurrency, prewarming the lambdas, direct resolvers for simple operations - https://youtu.be/i5NEHwFeeuY
- microservices - load balancing and traffic redistribution problems - (serverless caught cold start initially, but later was stable)
- microservices - better performance when fetching small size and repetitive requests - additionally lower cost compared to serverless
- serverless - more agile in terms of scalability (delays with rebalance from the microservice architectures)

# Serverless Computing: An Investigation of Deployment Environments for Web APIs

- serverless - pay per use, automatic resource provisioning and allocation, elastic automatic scaling, high availability

comparison web API on serverless and VMs

- no significant response time difference for expected load and test scenarios are within the FaaS hardware Limitations
- high number of concurrent requests - serverless effortlesly, VMs require additional labour
- advantages of serverless, but needs carefullu measure costs, adding all components
- comparing monolith, microservice and serverless

- user based factor - response time
- take into consideration cost

- (Adzic and Chatley) - 2 production applications successfully transitioned to serverless, lower hosting cost, high-throughput applications are better than high-availability one
- (Eivy) cheaper on VMS when predictable load
- microservices and containers also viable

- C\#, 4 endpoints, 6 functionalities, sharing most of the applciation code, only the entrypoint differs, the same code used for business logic, relational database access and file storage
- CRUD, file handling functionalities are compute-bound (traverse file content, find all sequences matchin patterns) and memory-bound (number of files, each file processed on different thread)
- comparable parameters in terms of the CPU and memory between FaaS, microservice and monolith

- there is some initial traffic before conducting the load test - there is no cold start

results

- 6 functionalities chained into 4 use-cases simulating real user behaviour
- 1-6 load runs - compare FaaS, Microservices, Monolith
- 7-9 - compare AWS and Azure FaaS

predictable user growth

- monolith initially faster than FaaS, but quickly degrades performance
- microservices degrade slower, due to the fact that the requests are spread across multiple VMs
- FaaS response time almost constant
- ~200 users for VMs close to max capacity
- ~100 users case - single VM handles all of the requests for monolith, reaching max capacity, for microservices it's distributed and not all machines are indicate full capacity occupation

unexpected user growth

- microservices and FaaS ahrdly affected by ~40 user ramp-up
- monolith does not differ from gradual to rapid rampup
- microservices reponse time affected by change in ramp-up

paylaod increase

- monolith performs better, while microservices the worse
- FaaS similar to monlith, but higher error rate
- monolith the best throughput ~ influenced by the amount of memmory and CPU available for each request, monolith on more powerful machine, every request can utilise the whole availabe CPU and memory at a time, microservices seemd to be underprovisioned, FaaS cannot borrow resources as monolith

scaling

- on FaaaS automatic and handled pretty good for all ramp-up types
- when enabling horizontal autoscaling (2/3 machines per VM) for Monolith and Microservices - comparable when VMs are properly provisioned - coudl match the performance of VMs
- predictable user loads, properly handled by both VMs and FaaS deployments, comparable response time
- unexpected user growth handled properly by FaaS due to autoscaling capability
- microservices seem to handle load better, cause it's laod balanced across machines

AWS vs Azure

- AWS Lambda performs better, averaging half of the responses
- both seems to have growth spikes in response time after full load is reached
- Azure seems to catch up near the end of the test

removing external dependencies like access to database, replaced with dummy data

- comparable response times for both aWS and Azure
- AWS autoscaling reacts faster, but when both stabilized the differences are insignificant

concurency limits - AWS 1000, Azure 200

- Azure better perf when the concurrency limit surpassed, but higher error rate
- without dependencies (db) - Azure a little better ~tens of ms
- with dependencies - AWS muhc better (50\%) - the significant difference between providers in response time is related with other dependencies, FaaS execution time is only small fraction of this, there is a need to consider other infrastructure components

cost (\# porównywanie jabłek z gruszkami)

- VM deployments 12x cheaper, however no scaling capabilities, when scaling VMs only 6x cheaper
- serverless - any performance optimisation , reducing the resource consumption or reponse time - impacts directly the cost
- additional cost - data transfer, load balancer, ip addresses, database storafe + albour cost not included in computation - some are VM specific and will make the cost higher
- cost significantly lower for VMs, but performance better for serverless

- end user perspective - performance as response time
- no considerable differences in response time when VMs are properly configured with respect to load - additional effort and money invested in VM deployments to match FaaS capabilities
- usage predictability - help reduce cost significantly, VM deployemnts are several times cheaperwhen properly configured to load which is steady/significant - but in research does not count the maintennace and configuration cost of VMs
- FaaS succesfully handlesunexpected user growth as built iin, additional effort required to setup it on VMs to match these capabilities
- when payload increase - scaling out FaaS does not help, more resources on VM can provide more resource for the processing
- serverless FaaS offerings responses are comparable, but the 3rd party components introduce significant latency, affecting overall user experience
- many variables when selecting the deployment technique - many more variables on top of response time and cost

# New API implementation with serverless GraphQL

- sending data between client and server cost time ~ user experience ~ reducing the amount of data can improve the loading times in the applications
- REST - minimize the amount of data being transferred by tailored data endpoints, providing only the necessary data - comes with extra price in form of increased development time, coples client view with the endpoint
- graphql - allow client to describe the required data, declarative data fecthing + runtime, prevents overfetching, does not need new endpoint for different queries

REST

- set of constraints, client-server components separation, stateless, cacheable, uniform interface - all info as resources, layered system
- decoupling components + statelesss = scalable system, server dictates granularity of the resources, overfetching, client view thightly coupled to the backend server endpoint

GraphQL

- more flexibility, declaratively define data, models data as graph instead of relationst - beneficial for highly connected data
- schema to define types and queries, nodes and how they're connected - modeling relations between entities
- queries - declarative description of data being fetched, defining fields to be fetched = prevents overfetching, can add more fields without intefering with the frontend

- single custom REST endpoint offered better performance than GraphQL, which reduced times for parallel and sequential data flows
- GraphQL - better data utilisation and reduced complexity compared to REST

research

- latency overhead for GraphQL - measuring specific points of the API call execution (cause of AWS - CloudWatch)
- ease of the development
- cost

architecture

- client makes a call to public API, which authenticates the user and redirects the request to the private API

backend

- Appsync - aboid maintenance burden implementing a custom GraphQL server, focus on business logic instead of dev and maintenance GraphQL server
- Amazon Aurora Serverless as storage
- AppSync resolves each field by proper resolver
- pipeline resolvers, when multiple actions required to resolve a field, combining multiple sequential operations into 1 resolver
- Apache VTL templates to apply transforamtions at different stages of pipeline
- before/after templates in the beginning/end of the pipeline, request/response -
- NewsAPI = 3 functions

  1. news from companies that user follows - calling the private API to return response
  2. if user not follows any company - queries nwes from companies in user portfolio - calling the private API to return response
  3. querying new to the companies retrieved from 1. and 2. - calling the lambda querying news database

- measuring overhead of AppSync when resolving the API call for the news (containing from several sources combined to resolve the whole call)

cost

- pay-as-you-go 4\$ per 1 milion query+ data transfer charged at the EC2 data transfer rate

- AppSync latency 26\% of the toal API call (147ms from 557ms) - slower than REST
- GraphQL easier to develop on frontend than REST (all Redux things, not really...),
- GraphQL more complex query parsing than REST, using AppSync to outsource the work of maintaining the GraphQL server to the service

# Leveraging serverless cloud computing architectures

- research effort containing extensive literature analysis
- goal - framework for designing serverless architecture / migrate existing applciation to serverless

framework

- 4 viewports - configuration, software design, software architecture, deployment)
- 5 cross-viewport variables (performance, vendor lock-in, security, cost, serverless sustainability)
- supported by recommendations and best practices
- evaluated by applying it to case study, performin interview with the domain experts - if aligned with software architecture design and dev practices

benefits

- granular autoscaling, based on execution time than resource allocation
- inherent fault tolerance, effortless parallelisation, function composition to create a business value through workflows
- reducing lead time, choose language, dependencies, tools

cons

- performance related challenges - cold starts, increased complexity in managing performance issues due to serverless platform out of control - unpredictability of FaaS makes it difficult to ensure quality
- FaaS / serverless specific deployment tools, concepts, monitoring, debugging
- vendor lock-in potential
- hard to decompose existing app into serverless

- novelty of serverless architecture - researchers and practitioners have yet to establish the knowledgebase with regards to implementation standards, cost savings techniques, performance optimisations, best practies
- serevrless used by practitioners, but from academic point of view, no reference architecture proposed, accumulating the knowledge on the topic
- guide as usable knowledge with regard to serverless architecture, missing scatered knowledge, likely to misuse, implement antipattern -> generating more cost, worsen performance, by not using the serverless benefits

- most desired benefits: cost savings and improved agility, readuced lead time
- many businesses don't use the serverless due to unknowns - complex cost structure, performance challenges, uncertainities regarding the implementation
- motivation: serverless has lot of benefits, but due to novelty and high architectural and economical impact adoption is lacking, successful serverless adoption depends on many factors
- goal of thesis: provide framework, guidance when moving existing architecture to serverless

RQ1 - benefits and challenges - what technology has to offer, knowing challenges - new level of insight
RQ2 - existing approaches, characteristis - which parts are suitable to be implemented as serverless - if certain part of the system will benefit from the migration to serverless
RQ3 - how cloud native architectures coposed and orchestrated to bring full potential of serverless - how serverless can be composed and orchestrated into large cloud native solution and achieve full potential of serverless, heterogenous nature of the system is a challenge, how to maximise benefits of each infividual sort of services
RQ4 - best practices when building serverless from scratch / when migrating existing service - from non-serverless to hybrid serverless solutions, formalize the body of knowledge - provide assistance for devs and architects when they'd be faced with such challenge
RQ5 - how best practices can be applied to support software architects / developers - summary of RQ

benefits:

- granular scaling - scaling individual services in microservices, compared to monoliths, but microservices deployment, operating, scaling is not that easy - serverless to fill the gap, creating microservices without managing servers, can be easily deployed and scaled automatically, easily parallelize heavy workloads (fanout appraoch, processing multiple concurrent jobs reducing total execution time), scaling handled by provider, new request - new container, especially beneficial when hard to predict
- optimisation of resource utilisation - granular scaling, improved resource usage to actual demand, VMs continuously running and scheduled to handle peak performance, there is autoscaling for vms and containers but it's not always quick enough (see 1. article with FaaS vs. microservices), implicit fault tolerance - when error occurs within a FaaS when processing, function is retried with the same input - depends on when the processing failed - it need to be properly handled
- operational cost reduction - beneficial for unpredictable, low usage \~ billing based on execution time, (Warzon) comparison lambda to EC2 instance based on request/hour, (Villamizar) comparison Lambda, microservices and monolith, (Adzic \& Chatley) 2 real life apps Minmup and Yubl - 66\%-95\% - moving rarely used and CPU intensive exporters to lambda, Yubl - quickly scale to spike demands, implicit failover, moving from capital to operational expenses - no need to buy hardware, pay-as-you-go, more granular cost monitoring
- architectural oportunities - inherent fault tolerance, effortless parallelisation of computing, automatic horizontal scaling, very easy to distribute and parallelise load, FaaS not designed for chaining functions to form workflow, AWS Step Functions allows developers to chain / compose multiple functions
- improvement in the development process - choosing language / libraries for function independently, reducing lead time, trying out new solutions, faster feedback improve rapid iterations, more frequent releases - because no need to manage infra and other operational aspects

challenges:

- performance issues - cold starts, high latency due to http protocol, basic scaling and scheduling policies, underlying serverless platform performance is not predictable,
- development complexities - new architecture = need to change mindset, FaaS stateelss and need to preserve the state somewhere, integration testing is harder and implies cost, complexity due to distributed nature, FaaS interoperability - each vendor different FaaS implementation, besides platform: scaling, resource usage, performance may also differ, tooling for serverless - testing, running code locally, distributed monitoring, deployment, monitoring, debugging especially difficult, greater granularity - logging, monitoring, versioning, documentation for each function independently
- migration and decomposition challenges - creating workflows, hybrid clouds, how to incorporate serverless function into microservices architecture, no reference architecture for serverless / guidelines, how ti decompose monolith or microservice
- increased monitoring difficulties - short living FaaS containers, events getting through distributed system, accessing multiple services, function execution time directly connected with the cost
- vendor lock-in - different FaaS interfaces, platform specific storage, logging, monitoring, configuration management, auth services and more - convenient to use at first, impossible to move to other provider later, client connect directly to other services
- security concerns - additional security challenges, new security issues like running FaaS are sharing resource
- operational cost reduction is not straightforward - billing heavily depends on the execution behaviour and volumes of workload, cost prediction is difficult and estimated based on the deployment environment behaviour, additional cost related with service usage, data egress (leaving the local network to exteranl location) - the overall cost adds up, to low execution of FaaS

suitability:

- it's still not clear where serverless is suitabl, usecases from cloud vendors shows where serverless is suitable, but not where it is not
- response time - software highly performant and fulfil certain response time (cold starts, platform performance), depends of use case if performance is acceptable, good for async / background jobs, larger packages with lot of deps take longer to initailize
- invocation patterns - low utilisation or dynamic and irregular workloads are a good fit for serverless architecture - cause of scaling to 0 and quickly scaling based on demand, software with consistent traffic will cost less with VMs
- type of operations - I/O (read/write on database or heav networking) and CPU bound (image editing, mathematical calculations) - CPU bound is better for serverless, I/O intensive can be relatively slow - function needs to wait and be billed for idle, due to stateless nature - each invocation creates a new connection with I/O service - low performance compared iwth dedicated VM caching the connections, inherent fault tolerance = functions need to be idempotent, to handle retries properly
- data limits - available disc space for lambda, package size, request payload - limits inherently connected with technology
- vendor dependence - relevant topic for serverless architectures, relatively high price for data egress which may be not suitable for hybrid solutions

composition of serverless - with existing app/microservice, hybrid cloud

- lack of adequate coordination mechanism between functions, lack of coordination mechanism, FaaS not conceived with the ida of complex workflow in mind, AWS Step Function shows how the composition can be made
- serverless trilemma - inherent challenge in serverless composition - 3 constraints: function should be a black boxes, composition of function should be a function, invocations should not be double billed - composition will always suffer from one or more of the three constraints - shows limitations, indicates which constraints would be suitable and which not
- 2 types of composition: function orchestrating other functions (entry function delegating work to other functions, trillema -violates the double billing), external client scheduler (external service orchestrating several function into workflow - AWS Step Function, forwarding request to corresponding functions, trillema - violates the composition should be a function),
- composition on the client side - complexity, cost, performance degradation
- services - AWS Step Function provides a visual tool for creating and debugging, additional overhead because of using the service, (Garcia Lopez) overhead of Azure Durable function, IBM composer and AWS Step Function are too high
- modeling - TOSCA for modeling services orchestration
- methods and tools - custme runtime environment, deploying docker on AWS lambda, PyWren - open-source, allows running Python code
- hybrid and multicloud composition - deployment to multicloud much harder, orchestration broker helping with that
- serverless usecases - pay-as-you-go appealing for scientific computing
- improve serverless composition

best practices for creating and migrating towards serverless architecture

- performance
  - (Bardsley, Ryan, Howard) keep the serverless function callstack short (each function, link in hte chain introduces communication latencies and suffer from cold starts), wisely choosing programming language (Python, Node, interpreted - faster init, Java, C\# - compiled better performance), different language behaviour on different clouds
  - sold starts - pinging FaaS within interval to keep them warm, but it's going against the idea of serverless + additional cost = consideration if VMs aren't better, reducing overall size of bundle (libraries), increase RAM -> CPU increase, reduce execution time -> less function available, cold start hit less frequently
  - I/O bound - serverless best suited for CPU bound, executing async operation and passing result to other function (similar to idea of suspending the function), reusing database conenctions when FaaS communicate with the database (each execution opens new connection, allow to reuse the same connection in next execution, store the database connection in local memory, next invocation can use the invocation from the previous execution, works only on warm instances, js - closure)
- security - applying proper access management, FaaS by default not permitted to do anything, only access to whitelisted, reducing possibility of breach,
- vendor lock-in - ports and adapters based architecture, abstraction between business logic and external components, quick switching of adapters to other database, other external services
- cost - cost simulations and algorithmically optimise it, not many cost related best practices, keep function chain short, proper monitoring allows to track cost, proper security measures preventing for example DDoS, if app experiences consistent and steady load - serverless can be more expensive
- monitoring and debugging - live debugging locally possible, distributed not that much, a priori log-based debugging, CloudWatch as monitoring automatically collecting the logs - considered as vendor lockin, set custom alerts, gain insight into req/res combination, very cloud platform specific, most prequently provided by cloud platform
- architecture and migration - ()Grumuldis 3 code pattersns for serverless utilising serverless framework,
  - monolithic pattern - single entry point executiong various function based on payload, good when migrating legacy code, downsides: hard to monitor, larger package size
  - service pattern - FaaS handling all requests for specific business logic, better separation of concerns, monitoring and debugging, reduces package size
  - nano-service pattern - each function has very specific responsibilities , for example CRUD, monitoring and debugging easier, better resource allocation by spreading the load, reduces impact of bugs, downside - infrequent execution -> cold starts

AWS guidelines

- separate the serverless function handler from core logic
- minimize package size of the deployed function = minimize execution time
- use env vars to modify function behaviour - env vars can be changed on the fly ~ feature flags
- contain deps in the function, rather than transporting them from CDN
- X-Ray (monitoring) and StepFunction (composition) work together very well - but vendor dependency and cross-platform restriction

- migrating monolith -> service -> serverless
- (Jambunathan, Yoganathan) microservices and serverless are complementary - optimal to use in conjunction
  - serverless - stateless, short running tasks, precise scaling - use when really needed, substantial improvement, not considered default due to more comples dev and operational
  - micro - statefull and long running

Amazon Well Architected

- operation as code, docs, more smaller and frequent changes
- implement strong identity foundation - traceability, automate security, protect data in transit
- test recovery procedures, automatic recover, scaele horizontal to aggregate system availability, automation for changes
- use new technologies
- adopt consumption model, measure efficienty, cost etc., use managed service to reduce cost

- port and adapter for migration monolith -> micro
- use available serverless framework - help with portability, abstract away the various cloud platforms offering standards, abstract away technology specific

conclusions:

- RQ1 - benefits considered as goals on this work for applying serverless architecture, when thinking about he successfulness, challenges - how to avoid how to introduce workarounds
- RQ2 - Grumuldis, Volker - set of characteristics was identified concernig serverless sustainability - response time, invocation patterns, type of operations, data limits, venoder dependence, runtime restrictions - flow chart summarising when serverless is not suitable
- RQ3 - composition of serverless function is possible, existing cloud standards only focus on a specific cloud service category, lack of reference architecture for serverless cloud computing apps, but could assist developed and architects, currently services offering single entry point which start cloud based workflow of multiple serverless functions, moving the complexity to cloud provider, using broker layer to communicate between cloud and onpremise architecture

RQ4 - what are the best practices for creating serverless apps

- literature review - not that much usable patterns, grey literature from practitioners and companies actively using serverless - some more info
- performance - many comparisons in literature, quite few strategies to optimise the latency, serverless best suited for background tasks, which not directly require client interaction, separate user from serverless execution = make use of event-driven architecture + non-blocking UI
- security - larger attack surface, but when applying proper access management
- vendor lock-in - not as limitation but as tradeoff, serverless platforms provides services with features that cannot be replaced, but on the other hand it tightens the vendor lock in, lloking for patterns for quicker switching the vendor or building vendor agnostic business logic - ports and adapters, firsty move monolith to microservices, alter to serverless
- serverless not always way to go, many situations when VMs and containers are more economical and performant - rule of thumb - app is experiencing consistenly spread load - cheaper with dedicated instance, but if fluctuating or low - serverless could bring cost savings

---

Artifact DSRM

Viewpoints - problem domain into subdomains, different perspectives on certain topic

1. configuration - deploy and maintain serverless architecture, esp. when going all in, when need to connect many services, FaaS also configurable (RAM/CPU)

- choosing right programming language for the job - best suited for the problem, in general compiled languages perform faster, but interpreted initialise faster (shorter cold starts)
- when slow function execution - consider upgrading the RAM and CPU - higher execution cost/time but if function is CPU bound it can be substantially faster - compensate for higher execution cost = faster performance and lower or equal cost

2. software design - code level desing with serverless tightly connected to the underlying platform

- design for performance - identify how to optimise it or work around it

  - cold start - when app has consistent load, cold-starts will occur less likely, reduce package size - smaller package = quicker init
  - keep functions warm - provisioned concurrency, plugins for "keep-alive" pinging functions
  - when load is predictable, it can be more beneficial to use container than serverless function - lower cost
  - keep functions chain short - each function adds latency due to cold start and
  - I/O bound operations can be expensive and ow performant in serverless when function sits idle; event based approach as workaround - dispatch events initiating I/O operation, another function is listening on event that is dispatched when operation completes

- function re-use and grouping

  - granularity of functions = hard to manage
  - group together similar functionalities, improves reuse
  - decouple core logic from handler - core logic included as library

- consider granularity of code patterns
  - does not make sense to have large granularity for small app, larger apps can benefit from greater granularity due to separation of concerns
  - levels of granularity: monolith, service based, nano-service
  - more granular - greater overhead with deploy, monitor, development, the more granular you go - more likely to observe cold starts - more individual functions with lifecycle on their own

3. software architecture - higher level structure of software, perspective on composition of serverless function with alrger app

- serverless trilemma - function should be black boxes, composition of function be a function, invocation should not be double billed - tradeoffs that are made
- composition style
  - chaining by calling other functions - hard to scale, hard to track which function calls which, violates 3. point of serverless trilemma, parent function waits for result and its billed
  - client focused composition - is client suitable to handle the composition, whihc can become complex
  - serverless composition service - reduces complexity on client side, easier development, does not violate double billing, but charged similar to functions, ahve additional performance overhead
  - vendor lock-in - losely coupled by ports and adapters as brokering layer, middleware functionality for connecting various services
  - keep function chain short - reducing latency (cold starts), increases complexity

4. deployment - important in cloud native apps, greater granularity = granular scaling, operational cost reduction, but eahc cloud = different approach and tool

- cloud platfomrs and their differences

  - different providers characteristics
  - vast ecosystem of tools, services, APIs

- hybrid and multi-cloud

  - hybrid - part on private and part in public
  - multi - - across multiple serverless
  - applying adapters and brokering layers reduces vendor locking

- using serverless framework
  - simplify development of functions
  - offfer standarisation and abstract away technical details
  - serverless framework - deploy to most of the largest FaaS providers

Cross-viewpoint variables - depends on the entire architecture and application, addressed by more than 1 viewpoint

- performance - affected by many aspects of serverless - 1, 2, 3
  - cold-starts affecting the performance
  - performance of various runtimes between cloud providers
  - I/O bound operations slows down the processing, ocnsider adoptin event-driven design pattern to overcome it
  - function composition - keep function chain short - prevent from accumulating latencies and cold starts
- vendor lock-in - serverless not designed for easy switching - 2, 3
  - ways ot recude switching cost (to another provider)
- security - a little different than classic one - 1, 3
  - larger surface attack, running serverless within VPC, shielding from the outside network
  - proper access management - Function only have access to resources they need - reduces possibilities of potential breach
  - dealing with DDOS - can become costly due to autoscaling - set budget alarms, API throttling can be applied for max application load
  - architectur edesigned with security in mind since the beginning
- costs - driver for going serverless, but it's not trivial to achieve - 1, 2
  - often one of the reasons of adopting serverless
  - non trivial - many variables, application workload
  - configuration of serverless function, runtime - determine cost per execution and performance
  - software architecture - determines how functions are invoked, how composition is handled
- serverless suitability - determine if the goal you're trying to achieve, part of software you're implementing or changing is suitable for serverless technology, serverless is very specific technology, it is very specific in what it can achieve and where it should be applied to get most benefits
  - it's needed to have a clear view on benefits and disadvantages of serverless - these can help determine if serverless is suitable
  - when serverless suitable: service experiences highly variable load, operations are CPU bound (not I/O), operations can be idempotent, low to moderate performant (not high, not mission critical), does not exceed serverless limits, can cope with serverless runtime restrictions, vendor lock-in is manageable

framework - conceptual model of the serverless architecture design problem domain, can be applied during app development process, describes most relevant concepts as well as non function characteristics identified as relevant to serverless

summary

- suitability - flows chart based on - response time, invocation pattern, type of operation, data limits, vendor dependence, runtime restrictions

# Become a Serverless Black Belt - Optimizing Your Serverless Applications - https://www.youtube.com/watch?v=4nrRt0dOcFk

- tips and tricks when building serverless architecture
- (screen) optimize - endpoint - sending request to queue, messaging service, orchestration service - calling lambda - calling storage
- optimisation katas:
  - lean functions
    - concise logic, efficient/single purpose code, ephemeral environment
    - lambda - code - inside language runtime - inside execution env (container) - inside compute substrate (server)
    - function lifecycle - download code, start new container (AWS optimisation side) | bootstrap runtime, start code (your optimisation)
    - AWS X-Ray - how function starts, how long cold start takes
    - consise function logic - separate lambda handler from the core logic (business logic), streamline the code into the function
    - function to transform the data, not transport the data - services can directly take the data
    - you're paying for any time function is doing I/O operation - read only what you need, filter the the input data to get inly what's needed
    - avoid "fat"/monolithic functions - too much capabilities and could be splitted
    - control dependencies packed to the function
    - optimise for language - minify, reduce unused code, import only what's needed - reduced amount of data put into artifact
    - lambda - single event per container
    - non-blocking execution on the frontend - don't make the function wait for response
    - lazyload variables, data
    - smart resource allocation - RAM ~ CPU, may not need all the RAM, but can benefit from more CPU - can cost a little bit more, but give drastic performance improvement
    - https://blog.newrelic.com/engineering/lambda-functions-xray-traces-custom-serverless-metrics/
    - https://github.com/alexcasalboni/aws-lambda-power-tuning
    - < 1.8 single core, but above is multi core - CPU workloads will gain, but need multi thread
    - async request - lambda kicks of running services, another function checks that - step function
  - eventful invocation -
    - succinct payloads, resilient routing, concurrent execution
    - client can invoke lambda directly, not needed API Gateway
    - discard uninterestin events ASAP - event prefixes
    - using api gateway supports protocol buffers
    - resiliency - order of operation, resiliency - kinesis vs sqs
    - retry policy - retires count as invokes
      - sync invocation - never retried - rely on client to reply
      - async - SNS/S3 invocation - invocation retried 2 times and the goes to DLQ - catching all failed messsages
      - streams - retired all the time
  - coordinated calls
    - decoupled via APIs, scale-matched downstreams, secured
    - building microservice based architecture
    - setting max concurrency for lambda - preventing DDoS, overutilisation of backend connections
    - VPC -
    - availability zones for better service resiliency
  - serviceful operations
    - automated operations, monitored applications, innovation mindset
    - serverless frameworks
      - claudia.js - define API which will be split into separate lambdas
      - SAM - serverless resources types - functions, API, tables
      - CodePipeline
      - CloudWatch - metrics, lambda logging
      - XRay - capturing events, profiling
      - serverless monoliths are not so good

# Optimizing serverless applications - https://www.youtube.com/watch?v=DYQ8pXrktBM

- focus on AWS Lambda
- compute substrate - all compute infra lambda manages on my behalf - networking, storage, load balancing

your function

- you can impact things - how you write the function, execution environment, configuration information
- pre-handler execution (during first initial cold start executed, these can be cached and reused between subsequent invocation) - import only what you need, prehandler code good for establishing the db connections, setting up env variables - these can be reused, but need to resolve issues with in the handler that the pre-handler env brings, doing stuff in prehandler will streamline to the handler execution - make sense to put things there - lazyload variables in to the global scope, don't load if you don't need, clean up the global scope that could affect subsequent execution call
- helper functions - get secrets/env vars, db connection, encryption using KSM - requires IAM permissions, vars - adding dynamics into the function - like feature flag, AWS Parameters Store - handling the key-value logic utilised as feature flags, Secret Store - similar to Parameter Store + lifecycle of secret management - sharing informations
- talking to other services using SDK
- simialr services - duplicated code for common things - pull it out and share across functions - extract to separate npm package in Node
- Lambda layers - sharing code between functions - deps, training data, configuration code, business logic - separate artifact for layers as zip file, could be custom runtime, layers are stacked
- concise function logic - separate handler from the core logic (could be put inside layer and shared across the functions),
- function to transform data, not transport - services can talk directly with each other
- take only the events that are meant for the function - reducing latency / amount of data being transported
- orchestration should be outside the lambda - sleep/longpoll - Step Function as orchestration service on top of lambda - decision tree, failure handling, parallelisation into workflows, integrations with sns, sqs, batch, fargate - dont write glue code to transport, run workers etc.
- Event Bridge - unique event busses - taking events from 1 place and passing them to another - event sources, event busses (connects sources, targets, rules)
- recap: minimise dependencies, use pre-handler logic to streamline data into the function, envs are ok for maller apps, but for larger Parameter Store could be more beneficial, reuse impact suhc as db connections, layers for code deduplication, concise logic - use higher level services, don't orchestrate in lambdas, push the orchestration into Step Function, Event Bridge, SNS, SQS

execution environment

- what's happening inside the lambda - XRay - lambda + API Gateway
- tweak function compute resources - increase RAM, increases the % of CPU and network capacity - when code CPU, Network, memory-bound - pulling data from S3, faster - cheaper, event though more expensive in time/price ratio
- Multithreading only above 1.8GB - running multiple processes
- Lambda API - invoking from client SDK, API Gateway not needed

execution mdoels

- sync - push based, API Gateway - calling lambda which respondes to the client
- async - SNS, S3 request going back to lambda, lambda performs the logic, no way to pass back to the originated client - should call next service
- stream - poll-based, dynamoDB, lambda runs a poller, watching for new messages, new data comming
- if you don't need a response, execute async - invoke lambda from lambda

concurrency control models

- SNS/API - no events store - pushed directly to the lambda - paralell lambdas
- queue based - SQS - batching messages into blocks, consume batched from the queue
- stream based - shard based model - ordering possible, concurrency on the shard level
- lambda per function concurrency control
- retries - different sources doing it differently - Dead Letter Queues - after mesasge failedto be consuemd several time - captured by the DLQ - after failed lambda function invoked asynchronously is retried twice, the message lands in DLQ (SNS) - prevent from losing the events - alarms on SQS length - reprocessing these events

security

- limit policies to required once only
- function policies - what can invoke the function
- execution role - what function can do, capabilities of function ,what services can be called from it
- SAM policy templates - set of predefined policies for most comon use cases - cheatsheet from IAM

recap: more memocy = more CPU, XRay for profiling workloads, 1.8GB enough for most of you unless multithread processing or network bound, think about the execution model - move to async to decouple services, thinking async will get you over som scaling challenges, understand queues, topics, streams

# AWS re:Invent 2020: Scalable serverless event-driven architectures with SNS, SQS & Lambda - https://www.youtube.com/watch?v=8zysQqxgj0I

messaging services

- SNS - pub/sub, push to consumer, producer sends a message to the topic, one more more subscribers (fanout), sub can choose to filter messages
- SQS - durable message queue, support any volume of message, one or more consumer polls the queue to receive messages (or batch of messages), at least once deliver - quarantee that message will be processed, consumer confirms that message has been consumed and processed, then it's removed, otherwise it will be visible once again after some time, lambda long-polls queues
- fanout (SNS) to queues (SQS)

lambda event processing 0 invocation models

- synchronous - API Gateway - sync call to lambda, blocks awaiting response from lambda
- asynchronous - SNS, S3 - fire and forget, return immediately to the client as soon as lambda picks up the event, no waiting no blocking
- stream (poll based) - SQS, Kinesis, DynamoDB streams - lambda polls the source, when event in queue it triggers the lambda

lambda scaling

- SNS - 1 event = 1 invocation - fire and forget
- SQS - buffered in the queue, processing batches, rate limitting the consumption (rate limitting by concurrency control - database with limit of connections)
- SQS - SQS by default best effort message ordering, at least once delivery (higher throughput and lower cost), FIFO queue mode - in order and exactly once message delivery

- SQS message groups - identified by message group id - messages from multiple groups can be processed at once, meanwhile poller can take messages from other group until the previous from the same group are processed
- message delivery quarantees - idemponent processing - handling idempotent processing
  - for fifo - heterogenous batch (from different groups), sort messages by MessageGroupId and SequenceNumber
  - exactly once - MessageDeduplicationId stored in database to distinguish if the batch was already processed

error handling

- posion messages - lambda throws error when processing, redrive policy - allows to set max attempt number after which the message lands in DLQ, messages can be deleted by ourselves - processing the succesful events
- SNS to lambda - up to 2 attempts more, then message is discarded / goes to DLQ

queue

- visibility timeout - retry the message
- leverage batching for cost savings and performance gains
- if batch size larger than 1 - catch errors and return altogether, delete successful processed messages from within the function before error
- speed up reprocessing - change per message visibility timeout to make them processed faster

SQS FIFO

- sort messages with MessageGroupId by SequenceNumber before processing
- Checkpoint processed batches by MessageDeduplicationId upon successful processing
- implement idempotency - messages received again after successful processing should be deleted altogether

SNS

- configure DLQ or lambda destination within function configuration
- enable subscription filter policies for consumers to limit SNS delivers and cost
- ensure lambda concurrency quota is sufficiently high to process the full concurrency of message ingested

rule of thumb

- if need fanout - SNS (if additionally need rate limiting - SNS + SQS)
- if don't - Lambda direct Invoke (if additional rate limit - SQS)

# AWS re:Invent 2019: [REPEAT 3] Serverless architectural patterns and best practices (ARC307-R3) - https://www.youtube.com/watch?v=9IYpGTS7Jy0

- lessons learnt form engineering, customers and partners
- gotchas and caviats when going large scales - different talk
- serverless as spectrum
- "create a lambda application" - creates basic CI/CD, tasks related to serverles, how to structure the code
- Jeremy Daly - serverless microservices patterns
- AWS Lambda Power Tunning - CPU/Memory/Network - test lambda function with different configuration - shows the performance/cost
- saga pattern - coordinated execution - process booking state machine - flights

REST API

- init - API Gateway - AWS Lambda - DynamoDB
- operations - AWS X-Ray (tracing) + CloudWatch (custom metrics + structured logic - standardize logs structure - easier queries - using CloudWatch, Kibana etc.)
- understand custoemr behaviour - limit access rate + auth - prevent from bots
- auth - Cognito + AWS Secrets Manager for sensitive data when apssing to lambdas (otherwise Parameter Store would be enough)
- Regional API Gateway enpoints support HTTP/2, Dynamodb on-demand pricing - unless you know the access pattern and can improve the configuration (if consistent throughput - provisioned capacity will be cheaper)
- use lambda power tuning - lambda optimisation

GraphQL API - "Cherry-pick"

- simple queries - DynamoDB as data source + VTL
- more complex logic - Lambda as data source
- compelx mutation - initBooking - in case of complex workflows, pipeline resolvers does not tell you much what in case of failures, what exactly fails - AWS Step Function with saga pattern
- Cognito - auth + authorization - per field resolving
- consistent model / contract on the frontend
- caching for GraphQL - caching server side - queries - cache per auth session with the same parameters, enable cache on resolver level - cache only some of the fields
- Appsync as API hub for various services

- single table design - performance increase, but you need to know the access patterns

WebHook - "call me, maybe"

- kinesis limit the concurrency of requests - aggregate to shard and batch as much as possible and then trigger the lambda - single invocation
- Lambda destination - piece of destination outside lambda - instead of sending to DLQ, more information
- DAZN powertools - obfuscate the sensitive data
- batch as much with kinesis - for low-volume traffic

Fanout

- API Gateway - lambda - sns - (multiple consumers - lambda + sqs) - lambda
- conenct directly - API Gateway - sns - (multiple consumers - lambda + sqs) - lambda
- SNS to SQS - batching, durability (SNS = 1 invocation, SNS+SQS will batch the events - better cost/performance ratio)
- DLQ dirrectly to SNS
- SNS will broadcast to multiple consumers - message filtering - invoke less and more efficient
- high throughput + huge payload - kinesis may be more suitable than SNS/SQS - lower cost

Streaming data

- API Gateway - AWS Lambda - Kinesis - S3
- backup raw data - events in the separate bucket
- dedicated Data Firehose per context/domain
- auth + obfuscate the data

Strangler

- migrating step by step - parts of the architecture
- hybrid cloud - some part on the Corporate data centers
- Api Gateway - VPC (with logs + XRay) - Load balancer with virtual IP
- side by side - lambda + DynamoDB

- serverless airline - https://github.com/aws-samples/aws-serverless-airline-booking/
- https://github.com/awslabs/realworld-serverless-application/wiki/AWS-Lambda
- logger + tracing the request + taggins - https://github.com/awslabs/aws-lambda-powertools-python
- https://github.com/getndazn/dazn-lambda-powertools

- don't opsess over pattern - great for learning - not always sufficient - learn from the patterns, see what make sense, experiment
- serverless - cognitive load for customers - start small, from small number of people

Architecturing and operating resilient serverless systems at scale

# AWS re:Invent 2020: AWS Lambda – Part 1: Optimizing your serverless applications - https://www.youtube.com/watch?v=Uw-DzFjCMC0

invoke side

- execution model
  - sync (push) - API Gateway receives request, talsk to backend - lambda with some business logic and goes back - client retries the logic when processing fails - what when multiple services forms a chain, how retries are handled? not encourageing to build such services but rather go async - first service triggerin other, confirming the client that the processing is finished
  - async (event - SNS, S3) - services invoke lambda on your behalf, but there is no way back, you need to trigger smth else continuing your process - if you don't need an immediate response, build async - poll the backend, push from websocket connection, EventBridge (bus), SNS (pub/sub), SQS (queue), kinesis - different characteristics, certain characteristics, how to handle retires, persistance, cost
  - stream (poll-based - DynamoDB, Kinesis) - lambda service polls the services, consume the data comming from these services
- concurrency
  - 1 lambda = 1 event regardless of event source or invoke type - batches pulled from Amazon Kinesis Data Streams, Amazon SQS, DynamoDB Streams = 1 event
  - concurrent requests require new execution environment - limit concurrency by burst rate per region
- handling retries and failures
  - sync - handled by the client
  - async - retries by default
  - streaming - depends on service - SQS batched retried, can be split and retry faield parts, kinesis - retried until expiration, can also be split
  - lambda destinations - failure handling - [assing event with bunch of medatada into the destination (lambda, EventBridge, SQS), pass on success - execute another lambda
  - DLQ - lambda, SQS, EventBridge - when fails, replay the events, monitor its length
  - don't use lambda for filtering (transporting), but rather transforming the data

integrated service side

- lambda storage options
  - 128 - 3008 MB - Memory
  - 512MB - /tmp space
  - <250MB - deployment package
  - lambda reaching EFS
- database connectivity
  - if you can use HTTP-based database - go DynamoDB - resource management is less of an issue
  - require more traditional database or caching - RDS Proxy - high available database proxy - pools and shares db connection to make app more scalable, resilient to db failures, secure
- managing secrets / config
  - configuration: env variables - specific to single lambda, Parameter Store, Secrets Manager (key rotation)

# AWS re:Invent 2020: AWS Lambda – Part 2: Optimizing your serverless applications - https://www.youtube.com/watch?v=rrK7PA8ZK7M

- deps, configuration, common helpers
- handler
- common function helpers
- business logic for function

- use layers for sharing common data, heavy dependencies

best practices

- cold starts

  - avoid monolithic functions - reduce deployment pakcage size - micro/nano services - more bytes need to go over the network, takes longer to bootstrap the function
  - minify/uglify production code - optimise size
  - optimize dependencies - use only what needed, NodeJS - import only specific modules, when working on dynamodb import only dynamodb from sdk instead of the whole sdk
  - lazy init shared libs - helps if there are multiple functions per file, init as undefined, and inside the handler load them if not present
  - reuse connections - keep-alive in AWS SDK
  - use provisioned concurrency - on individual functions - provision pre-warmed env

- performance / cost
  - external orchestration - avoid idle (waiting for the service response coming back), delegate to Step Function
  - use lambda to transform the data not transport
  - discard uninteresting events asap - filtering from S3, SNS
  - fine tune resource allocation - don't guestimate - AWS LAmbda Power Tuning - https://github.com/alexcasalboni/aws-lambda-power-tuning - data driven approach
  - lambda destination - simplify chaining async functions (when success) and handle errors similar to DLQ (when failure)

# TODO

- https://www.researchgate.net/profile/Davide-Taibi/publication/340121613_Patterns_for_Serverless_Functions_Function-as-a-Service_A_Multivocal_Literature_Review/links/5e79f9fb92851c3091392bd4/Patterns-for-Serverless-Functions-Function-as-a-Service-A-Multivocal-Literature-Review.pdf
- https://aws.amazon.com/lambda/resources/reference-architectures/
- Cloud programming simplified a berkeley view on serverless computing
- https://docs.aws.amazon.com/wellarchitected/latest/serverless-applications-lens/wellarchitected-serverless-applications-lens.pdf#welcome
- https://www.usenix.org/system/files/conference/hotcloud18/hotcloud18-paper-hong.pdf

- https://www.youtube.com/watch?v=Cs5e9vbjNdU - Build Modern Serverless Applications with GraphQL APIs and AWS AppSync - AWS Online Tech Talks
- https://www.youtube.com/watch?v=TOn0xhev0Uk - AWS re:Invent 2019: [REPEAT 1] Building microservices with AWS Lambda (SVS343-R1)
- https://www.youtube.com/watch?v=dgpLX1T0bKU - AWS re:Invent 2020: Understanding AWS Lambda streaming events

---

- https://maciejwinnicki.com/database-for-serverless-era/
- https://www.alexdebrie.com/posts/dynamodb-no-bad-queries/
- https://www.goingserverless.com/blog/how-to-build-an-appsync-api-using-a-single-table-dynamodb-design
- https://www.youtube.com/watch?v=KWOSGVtHWqA - AWS re:Invent 2017: [REPEAT] Which Database to Use When? (DAT310-R)
- https://www.youtube.com/watch?v=fiP2e-g-r4g - AWS re:Invent 2020: Data modeling with Amazon DynamoDB – Part 1
- https://www.alexdebrie.com/posts/dynamodb-no-bad-queries/

---

- https://mikhail.io/serverless/coldstarts/big3/
- https://aws.amazon.com/blogs/compute/building-well-architected-serverless-applications-controlling-serverless-api-access-part-1/
- https://www.serverless.com/blog/how-create-rest-api-serverless-components
- https://www.andmore.dev/blog/build-serverless-api-with-no-lambda/
