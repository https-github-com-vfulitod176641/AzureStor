% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sas.R
\name{get_account_sas}
\alias{get_account_sas}
\alias{sas}
\alias{shared-access-signature}
\alias{shared_access_signature}
\alias{get_account_sas.az_storage}
\alias{get_account_sas.storage_endpoint}
\alias{get_account_sas.default}
\alias{get_user_delegation_key}
\alias{get_user_delegation_key.az_resource}
\alias{get_user_delegation_key.blob_endpoint}
\alias{revoke_user_delegation_keys}
\alias{revoke_user_delegation_keys.az_storage}
\alias{get_user_delegation_sas}
\alias{get_user_delegation_sas.az_storage}
\alias{get_user_delegation_sas.blob_endpoint}
\alias{get_user_delegation_sas.default}
\title{Generate shared access signatures}
\usage{
get_account_sas(account, ...)

\method{get_account_sas}{az_storage}(account, key = account$list_keys()[1], ...)

\method{get_account_sas}{storage_endpoint}(account, key = account$key, ...)

\method{get_account_sas}{default}(account, key, start = NULL,
  expiry = NULL, services = "bqtf", permissions = "rl",
  resource_types = "sco", ip = NULL, protocol = NULL,
  auth_api_version = getOption("azure_storage_api_version"), ...)

get_user_delegation_key(account, ...)

\method{get_user_delegation_key}{az_resource}(account, token = account$token, ...)

\method{get_user_delegation_key}{blob_endpoint}(account,
  token = account$token, key_start, key_expiry, ...)

revoke_user_delegation_keys(account)

\method{revoke_user_delegation_keys}{az_storage}(account)

get_user_delegation_sas(account, ...)

\method{get_user_delegation_sas}{az_storage}(account, key, ...)

\method{get_user_delegation_sas}{blob_endpoint}(account, key, ...)

\method{get_user_delegation_sas}{default}(account, key, resource,
  start = NULL, expiry = NULL, permissions = "rl",
  resource_types = "c", ip = NULL, protocol = NULL,
  snapshot_time = NULL,
  auth_api_version = getOption("azure_storage_api_version"), ...)
}
\arguments{
\item{account}{An object representing a storage account. Depending on the generic, this can be one of the following: an Azure resource object (of class \code{az_storage}); a client storage endpoint (of class \code{storage_endpoint}); a \emph{blob} storage endpoint (of class \code{blob_endpoint}); or a string with the name of the account.}

\item{...}{Arguments passed to lower-level functions.}

\item{key}{For \code{get_account_sas}, the \emph{account} key, which controls full access to the storage account. For \code{get_user_delegation_sas}, a \emph{user delegation} key, as obtained from \code{get_user_delegation_key}.}

\item{start, expiry}{The start and end dates for the account or user delegation SAS. These should be \code{Date} or \code{POSIXct} values, or strings coercible to such. If not supplied, the default is to generate start and expiry values for a period of 8 hours, starting from the current time.}

\item{services}{For \code{get_account_sas}, the storage service(s) for which the SAS is valid. Defaults to \code{bqtf}, meaning blob (including ADLS2), queue, table and file storage.}

\item{permissions}{For \code{get_account_sas} and \code{get_user_delegation_sas}, the permissions that the SAS grants. The default \code{rl} (read and list) essentially means read-only access.}

\item{resource_types}{The resource types for which the SAS is valid. For \code{get_account_sas} the default is \code{sco} meaning service, container and object. For \code{get_user_delegation_sas} the default is \code{c} meaning container-level access (including blobs within the container).}

\item{ip}{The IP address(es) or IP address range(s) for which the SAS is valid. The default is not to restrict access by IP.}

\item{protocol}{The protocol required to use the SAS. Possible values are \code{https} meaning HTTPS-only, or \verb{https,http} meaning HTTP is also allowed. Note that the storage account itself may require HTTPS, regardless of what the SAS allows.}

\item{auth_api_version}{The storage API version to use for authenticating.}

\item{token}{For \code{get_user_delegation_key}, an AAD token from which to obtain user details. The token must have \verb{https://storage.azure.com} as its audience.}

\item{key_start, key_expiry}{For \code{get_user_delegation_key}, the start and end dates for the user delegation key.}

\item{resource}{For \code{get_user_delegation_sas}, the resource for which the SAS is valid. This can be either the name of a blob container, or a blob. If the latter, it should include the container as well (\code{containername/blobname}).}

\item{snapshot_time}{For \code{get_user_delegation_sas}, the blob snapshot for which the SAS is valid. Only required if \code{resource_types="bs"}.}
}
\description{
The simplest way for a user to access files and data in a storage account is to give them the account's access key. This gives them full control of the account, and so may be a security risk. An alternative is to provide the user with a \emph{shared access signature} (SAS), which limits access to specific resources and only for a set length of time. AzureStor supports generating two kinds of SAS: account and user delegation, with the latter applying only to blob and ADLS2 storage.
}
\details{
Listed here are S3 generics and methods to obtain a SAS for accessing storage; in addition, the \code{\link{az_storage}} resource class has R6 methods for \code{get_account_sas}, \code{get_user_delegation_key} and \code{revoke_user_delegation_keys} which simply call the corresponding S3 method.

Note that you don't need to worry about these methods if you have been \emph{given} a SAS, and only want to use it to access a storage account.

An \strong{account SAS} is secured with the storage account key. An account SAS delegates access to resources in one or more of the storage services. All of the operations available via a user delegation SAS are also available via an account SAS. You can also delegate access to read, write, and delete operations on blob containers, tables, queues, and file shares. To obtain an account SAS, call \code{get_account_sas}.

A \strong{user delegation SAS} is a SAS secured with Azure AD credentials. It's recommended that you use Azure AD credentials when possible as a security best practice, rather than using the account key, which can be more easily compromised. When your application design requires shared access signatures, use Azure AD credentials to create a user delegation SAS for superior security.

Every SAS is signed with a key. To create a user delegation SAS, you must first request a \strong{user delegation key}, which is then used to sign the SAS. The user delegation key is analogous to the account key used to sign a service SAS or an account SAS, except that it relies on your Azure AD credentials. To request the user delegation key, call \code{get_user_delegation_key}. With the user delegation key, you can then create the SAS with \code{get_user_delegation_sas}.

To invalidate all user delegation keys, as well as the SAS's generated with them, call \code{revoke_user_delegation_keys}.

See the examples and Microsoft Docs pages below for how to specify arguments like the services, permissions, and resource types. Also, while not explicitly mentioned in the documentation, ADLSgen2 storage can use any SAS that is valid for blob storage.
}
\examples{
# account SAS valid for 7 days
get_account_sas("mystorage", "access_key", start=Sys.Date(), expiry=Sys.Date() + 7)

# SAS with read/write/create/delete permissions
get_account_sas("mystorage", "access_key", permissions="rwcd")

# SAS limited to blob (+ADLS2) and file storage
get_account_sas("mystorage", "access_key", services="bf")

# SAS for file storage, allows access to files only (not shares)
get_account_sas("mystorage", "access_key", services="f", resource_types="o")

# getting the key from an endpoint object
endp <- storage_endpoint("https://mystorage.blob.core.windows.net", key="access_key")
get_account_sas(endp, permissions="rwcd")

\dontrun{

# user delegation key valid for 24 hours
token <- AzureRMR::get_azure_token("https://storage.azure.com", "mytenant", "app_id")
endp <- storage_endpoint("https://mystorage.blob.core.windows.net", token=token)
userkey <- get_user_delegation_key(endp, start=Sys.Date(), expiry=Sys.Date() + 1)

# user delegation SAS for a container
get_user_delegation_sas(endp, userkey, resource="mycontainer")

# user delegation SAS for a specific file, read/write/create/delete access
# (order of permissions is important!)
get_user_delegation_sas(endp, userkey, resource="mycontainer/myfile",
                        resource_types="b", permissions="rcwd")

}
}
\seealso{
\link{blob_endpoint}, \link{file_endpoint},
\link{Date}, \link{POSIXt},
\href{https://docs.microsoft.com/en-us/rest/api/storagerp/}{Azure Storage Provider API reference},
\href{https://docs.microsoft.com/en-us/rest/api/storageservices/}{Azure Storage Services API reference},
\href{https://docs.microsoft.com/en-us/rest/api/storageservices/create-account-sas}{Create an account SAS},
\href{https://docs.microsoft.com/en-us/rest/api/storageservices/create-user-delegation-sas}{Create a user delegation SAS}
}
